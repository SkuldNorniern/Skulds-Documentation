return {
	"rcarriga/nvim-notify",
	lazy = false,
	priority = 1000,
	config = function()
		require("bit")
		require("telescope").load_extension("notify")
		vim.notify = require("notify")
		-- require("notify")("Loaded notify", "info", { title = "Neovim" })
	end
}
