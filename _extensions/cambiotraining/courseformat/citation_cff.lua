-- Function to parse the CFF file
function parse_cff(file_path)
  -- Initialize tables to store extracted information
  local data = {
    title = "",
    year = "",
    month = "",
    url = "",
    authors = {}
  }

  -- Function to trim whitespace from the beginning and end of a string
  local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
  end

  -- Read the YAML content from the file
  local file = io.open(file_path, "r")
  local yaml_content = file:read("*all")
  file:close()

  -- Parse the YAML content line by line
  local current_author = nil
  local in_authors_section = false
  for line in yaml_content:gmatch("[^\r\n]+") do
    line = trim(line)
    
    -- Detect the start of the authors section
    if line:match("^authors:") then
      in_authors_section = true
    end
    
    -- Parse the title
    if line:match("^title:") then
      data.title = trim(line:gsub("title:", ""))
    end
    
    -- Parse the URL
    if line:match("^url:") then
      data.url = trim(line:gsub("url:", ""):gsub("'", ""))
    end
    
    -- Parse the release date and extract year and month
    if line:match("^date%-released:") then
      local date = trim(line:gsub("date%-released:", ""):gsub("'", ""))
      data.year, data.month = date:match("(%d%d%d%d)%-(%d%d)")
    end
    
    -- Start processing authors once in the authors section
    if in_authors_section then
      -- Detect a new author block by a line starting with "-"
      if line:match("^%- ") then
        -- Add the previous author to the authors list if it's not nil
        if current_author then
          table.insert(data.authors, current_author)
        end
        -- Start a new author
        current_author = {}
      end
      
      -- Populate author fields
      if line:match("given%-names:") then
        current_author["given-names"] = trim(line:gsub("%-?%s*given%-names:", ""):gsub("'", ""))
      elseif line:match("family%-names:") then
        current_author["family-names"] = trim(line:gsub("%-?%s*family%-names:", ""):gsub("'", ""))
      elseif line:match("affiliation:") then
        current_author["affiliation"] = trim(line:gsub("%-?%s*affiliation:", ""):gsub("'", ""))
      elseif line:match("website:") then
        current_author["website"] = trim(line:gsub("%-?%s*website:", ""):gsub("'", ""))
      elseif line:match("orcid:") then
        current_author["orcid"] = trim(line:gsub("%-?%s*orcid:", ""):gsub("'", ""))
      elseif line:match("alias:") then
        current_author["alias"] = trim(line:gsub("%-?%s*alias:", ""):gsub("'", ""))
      end
    end
  end

  -- Add the last author if it exists
  if current_author then
    table.insert(data.authors, current_author)
  end

  -- Return the extracted data
  return data
end

return {
  ["citation"] = function(args, kwargs)
    -- Read the CFF file into a table
    local cff_data = parse_cff("CITATION.cff")

    -- Extract relevant data from the parsed CFF
    local title = cff_data.title
    local year = cff_data.year
    local month = cff_data.month
    local url = cff_data.url
    local authors = cff_data.authors

    -- Generate APA-style author list
    local apa_authors = {}
    for _, author in ipairs(authors) do
        local name = author["family-names"] .. ", " .. string.sub(author["given-names"], 1, 1) .. "."
        table.insert(apa_authors, name)
    end
    local apa_author_str = table.concat(apa_authors, ", ")

    -- Generate APA citation
    local apa_citation = apa_author_str .. " (" .. year .. "). " .. title .. ". " .. url

    -- Generate BibTeX citation
    local bibtex_authors = {}
    for _, author in ipairs(authors) do
        local name = author["family-names"] .. ", " .. author["given-names"]
        table.insert(bibtex_authors, name)
    end
    local bibtex_author_str = table.concat(bibtex_authors, " and ")

    local bibtex_citation = string.format([[
@misc{YourReferenceHere,
  author = {%s},
  month = {%d},
  title = {%s},
  url = {%s},
  year = {%s}
}]], bibtex_author_str, tonumber(month), title, url, year)

    -- Generate the author information HTML
    local author_info = "<ul>"
    for _, author in ipairs(authors) do
        local name = author["given-names"] .. " " .. author["family-names"]
        local orcid_icon = author.orcid and '<a href="' .. author.orcid .. '" target="_blank"><i class="fa-brands fa-orcid" style="color:#a6ce39"></i></a>' or ""
        local email_icon = author.website and '<a href="' .. author.website .. '" target="_blank"><i class="fa-solid fa-envelope" style="color:#003E74"></i></a>' or ""
        local affiliation = author.affiliation and '<em>Affiliation</em>: ' .. author.affiliation .. '<br>' or ""
        local roles = author.alias and '<em>Roles</em>: ' .. author.alias or ""

        author_info = author_info .. string.format([[
<li><strong>%s</strong> %s %s<br>
%s %s
</li>
]], name, orcid_icon, email_icon, affiliation, roles)
    end
    author_info = author_info .. "</ul>"

    -- Generate the final output in HTML format
    local output = [[
<p>You can cite these materials as:</p>
<blockquote>
<p>]] .. apa_citation .. [[</p>
</blockquote>
<p>Or in BibTeX format:</p>
<pre class="sourceCode bibtex"><code class="sourceCode bibtex">]] .. bibtex_citation .. [[</code></pre>
<p><strong>About the authors:</strong></p>
]] .. author_info .. [[
]]

    -- Return the output as raw HTML
    return pandoc.RawBlock("html", output)
  end
}
