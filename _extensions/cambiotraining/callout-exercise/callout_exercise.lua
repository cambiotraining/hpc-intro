local number_exercises = true
local hide_answers = false
local exercises = {}  -- Table to store exercise IDs and titles
local exercise_counter = 0  -- Global counter for exercises
local seen_ids = {}  -- Table to track seen IDs and check for duplicates

-- function to throw a yellow warning
function warn(message)
  local yellow = "\27[33m"
  local reset = "\27[0m"
  io.stderr:write(yellow .. "WARN: " .. message .. reset .. "\n")
end

-- Meta function to read yml metadata
function Meta(meta)
  if meta["exercises"] and meta["exercises"]["number"] == true then
    number_exercises = true
  end

  if meta["exercises"] and meta["exercises"]["hide-answers"] == true then
    hide_answers = true
  end
end

-- Div function to process exercises and answers
function Div(div)
  -- Process callout-exercise divs
  if div.classes:includes("callout-exercise") then
    exercise_counter = exercise_counter + 1
    local exercise_number = "Exercise " .. exercise_counter  -- Always generate the number

    -- Store exercise ID and title if it has an ID starting with "ex-"
    if div.identifier and div.identifier:match("^ex%-") then
      -- Check for duplicate IDs
      if seen_ids[div.identifier] then
        warn("Duplicate exercise ID found: #" .. div.identifier)
      end

      seen_ids[div.identifier] = true
      exercises[div.identifier] = exercise_number
    end

    -- Process the header within the exercise
    if div.content[1] ~= nil and div.content[1].t == "Header" then
      local title = pandoc.utils.stringify(div.content[1])
      div.content:remove(1)  -- Remove the original header from content
      local final_title = number_exercises and exercise_number .. " - " .. title or title
      return quarto.Callout({
        type = "exercise",
        content = { div },
        title = final_title,
        icon = false,
        collapse = false
      })
    else
      -- If no header, use just the exercise number (if numbering is on)
      local final_title = number_exercises and exercise_number or nil
      return quarto.Callout({
        type = "exercise",
        content = { div },
        title = final_title,
        icon = false,
        collapse = false
      })
    end
  end

  -- Process callout-answer divs
  if div.classes:includes("callout-answer") then
    if (hide_answers and div.attributes["hide"] ~= "false") or div.attributes["hide"] == "true" then
      return pandoc.RawBlock('html', '<div hidden></div>')
    else
      return quarto.Callout({
        type = "answer",
        content = { div },
        title = "Answer",
        icon = false,
        collapse = true
      })
    end
  end

  -- Process callout-hint divs
  if div.classes:includes("callout-hint") then
    return quarto.Callout({
      type = "hint",
      content = { div },
      title = "Hint",
      icon = false,
      collapse = true
    })
  end
end

-- Replace cross-references in Pandoc elements
function Pandoc(doc)
  -- Walk through the document and replace any Str element that matches @ex-*
  local function replace_xref(elem)
    if elem.t == "Str" and elem.text:match("^@ex%-") then
      local id = elem.text:sub(2)  -- Remove the "@" prefix
      local exercise_title = exercises[id]
      if exercise_title then
        -- Return the custom HTML link
        local link_html = string.format(
          '<a href="#%s"><u>%s</u></a>',
          id,
          exercise_title
        )
        return pandoc.RawInline('html', link_html)
      else
        -- If the ID is not found, throw a warning
        warn("Undefined exercise cross-reference: @" .. id)
      end
    end
    return elem
  end

  -- Apply the replacement to all inline elements
  return doc:walk({
    Str = replace_xref
  })
end

-- Return the filter
return {
  { Meta = Meta },
  { Div = Div },
  { Pandoc = Pandoc }
}
