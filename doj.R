library(tidyverse)
# File from https://www.matthewproctor.com/australian_postcodes
pc2lga <- read.csv(file = "data/australian_postcodes.csv") |>
  as_tibble() |>
  filter(state == "VIC") |>
  select(postcode, locality, lgaregion) |>
  distinct() |>
  rename(lga = lgaregion)
# Info from https://m.vic.gov.au/contactsandservices/directory/?ea0_lfz149_120.&organizationalUnit&bf850032-8b0f-410c-a5e1-b6f22695c09a#
lga2doj <- bind_rows(
  tibble(
    lga = c(
      "Colac Otway", "Corangamite", "Glenelg", "Greater Geelong", "Moyne",
      "Queenscliffe", "Southern Grampians", "Surf Coast", "Warrnambool"
    ),
    doj = "Barwon South West"
  ),
  tibble(
    lga = c(
      "Bass Coast", "Baw Baw", "East Gippsland", "Latrobe City",
      "South Gippsland", "Wellington"
    ),
    doj = "Gippsland"
  ),
  tibble(
    lga = c(
      "Ararat", "Ballarat", "Golden Plains", "Hepburn", "Hindmarsh",
      "Horsham", "Moorabool", "Northern Grampians", "Pyrenees",
      "West Wimmera", "Yarriambiack"
    ),
    doj = "Grampians",
  ),
  tibble(
    lga = c(
      "Alpine", "Benalla", "Greater Shepparton", "Indigo", "Mansfield",
      "Mitchell", "Moira", "Murrindindi", "Strathbogie", "Towong",
      "Wangaratta", "Wodonga"
    ),
    doj = "Hume",
  ),
  tibble(
    lga = c(
      "Buloke", "Campaspe", "Central Goldfields", "Gannawarra",
      "Greater Bendigo", "Loddon", "Macedon Ranges", "Mildura",
      "Mount Alexander", "Swan Hill"
    ),
    doj = "Loddon Mallee",
  ),
  tibble(
    lga = c(
      "Banyule", "Darebin", "Hume", "Melbourne", "Moreland", "Nillumbik",
      "Whittlesea", "Yarra", "Brimbank", "Hobson's Bay", "Maribyrnong",
      "Melton", "Moonee Valley", "Wyndham"
    ),
    doj = "North West Metropolitan",
  ),
  tibble(
    lga = c(
      "Boroondara", "Bayside", "Cardinia", "Casey", "Frankston",
      "Glen Eira", "Greater Dandenong", "Kingston", "Knox", "Manningham",
      "Maroondah", "Mornington Peninsula", "Monash", "Port Phillip",
      "Stonnington", "Whitehorse", "Yarra Ranges"
    ),
    doj = "South East Metropolitan",
  )
)
lookup <- left_join(pc2lga, lga2doj, by="lga") |>
  select(-lga) |>
  mutate(
    locality = str_to_title(locality),
    postcode = as.character(postcode)
  ) |>
  rename(
    `Postcode` = postcode,
    `Locality` = locality,
    `Department of Justice Region` = doj
  )

