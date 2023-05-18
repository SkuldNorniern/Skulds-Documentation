local function cmd(s)
  return ("<Cmd>%s<CR>"):format(s)
end

return {
  i = {
    -- ESC alternative
    ["kj"] = "<Esc>",
  },
  n = {
    ["<Leader>w"] = cmd("write"),
    ["<Leader>W"] = cmd("wall"),
    ["<Leader>q"] = cmd("quit"),
    ["<Leader>Q"] = cmd("quit!"),
  },
}
