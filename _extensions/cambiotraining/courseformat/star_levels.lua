return {
  ['level'] = function(args, kwargs)
  
    local nstars = pandoc.utils.stringify(args[1])
    local star_icons = ""
    
    if nstars == "1" then
      star_icons = "<font style='font-variant: small-caps'>Level:</font> <i class='fa-solid fa-star'></i><i class='fa-regular fa-star'></i><i class='fa-regular fa-star'></i><br>"
    elseif nstars == "2" then
      star_icons = "<font style='font-variant: small-caps'>Level:</font> <i class='fa-solid fa-star'></i><i class='fa-solid fa-star'></i><i class='fa-regular fa-star'></i><br>"
    elseif nstars == "3" then
      star_icons = "<font style='font-variant: small-caps'>Level:</font> <i class='fa-solid fa-star'></i><i class='fa-solid fa-star'></i><i class='fa-solid fa-star'></i><br>"
    end
    
    return pandoc.RawInline("html", star_icons)
  end
}
