return {
  -- add new filetype "nuklues"
  {
    { "BufRead", "BufNewFile" },
    pattern = "*.nk",
    callback = function()
      vim.bo.filetype = "nukleus"
      vim.bo.syntax = "rust"
    end,
  },
}
