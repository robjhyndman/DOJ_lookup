library(tidyverse)
# File from https://www.matthewproctor.com/australian_postcodes
# File from https://www.matthewproctor.com/australian_postcodes\
# Last downloaded 6 January 2023
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
      "Bass Coast", "Baw Baw", "East Gippsland", "Latrobe",
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
      "Whittlesea", "Yarra", "Brimbank", "Hobsons Bay", "Maribyrnong",
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

# Fix problems with Baw Baw and Yarra Ranges
problem_postcodes <- anti_join(pc2lga, lga2doj, by="lga")$postcode
bawbaw <- c(3816, 3818, 3820:3825, 3831:3833, 3835)
yarraranges <- c(3116,3138,3139,3140,3158,3159,3160,3765,3766,3767,3770,
  3775,3777,3779,3785,3786,3787,3788,3789,3791,3792,3793,3795,3796,3797,3799)

pc2lga <- pc2lga |>
  mutate(
    lga = case_when(
      postcode %in% intersect(problem_postcodes, bawbaw) ~ "Baw Baw",
      postcode %in% intersect(problem_postcodes, yarraranges) ~ "Yarra Ranges",
      TRUE ~ lga
    )
  )
# Any problems left?
#anti_join(pc2lga, lga2doj, by="lga")

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

