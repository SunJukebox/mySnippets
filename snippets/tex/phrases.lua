local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

snips = {
	s({ trig = "cf", name = "cross refrence" }, fmta([[\cite[<>]{<>}]], { i(1), i(2) }), {
		condition = tex.in_text,
		show_condition = tex.in_text,
		callbacks = {
			[2] = {
				[events.enter] = function()
					require("telescope").extensions.bibtex.bibtex(
						require("telescope.themes").get_dropdown({ previewer = false })
					)
				end,
			},
		},
	}),
}

autosnips = {
	s(
		{ trig = "qf", name = "Q-factorial" },
		{ t("\\(\\mathbb{Q}\\)-factorial") },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "bqf", name = "base point free" },
		{ t("base point free") },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "Tfae", name = "The following are equivalent" },
		{ t("The following are equivalent") },
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }
	),

	s({ trig = "([qr])c", name = "Cartier", regTrig = true }, {
		f(function(_, snip)
			return "\\(\\mathbb{" .. string.upper(snip.captures[1]) .. "}\\)-Cartier"
		end, {}),
	}, { condition = tex.in_text, show_condition = tex.in_text }),

	s({ trig = "([qr])d", name = "divisor", regTrig = true }, {
		f(function(_, snip)
			return "\\(\\mathbb{" .. string.upper(snip.captures[1]) .. "}\\)-divisor"
		end, {}),
	}, { condition = tex.in_text, show_condition = tex.in_text }),
	s({ trig = "([wW])log", name = "without loss of generality", regTrig = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "ithout loss of generality"
		end, {}),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),

	s(
		{ trig = "cref", name = "\\cref{}" },
		fmta([[\cref{<>}]], { i(1) }),
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
}

local phrase_specs = {
	-- cf = "cf.~",
	ses = "short exact sequence",
	klt = "Kawamata log terminal",
}

local auto_phrase_specs = {
	iee = "i.e., ",
	egg = "e.g., ",
	stt = "such that",
	resp = "resp.\\ ",
	cd = "Cartier divisor",
	wd = "Weil divisor",
	nc = "\\((-1)\\)-curve",
	iff = "if and only if ",
	wrt = "with respect to ",
	nbhd = "neighbourhood",
	pef = "pseudo-effective",
	gbgs = "generated by global sections",
	fgd = "finitely generated",
	mfs = "Mori fibre space",
	snc = "simple normal crossing",
	lmm = "log minimal model",
	tfae = "the following are equivalent",
}

local phrase_snippet = function(context, body)
	context.dscr = context.trig
	return s(context, t(body), { condition = tex.in_text, show_condition = tex.in_text })
end

for k, v in pairs(phrase_specs) do
	table.insert(snips, phrase_snippet({ trig = k }, v))
end
for k, v in pairs(auto_phrase_specs) do
	table.insert(autosnips, phrase_snippet({ trig = k }, v))
end

return snips, autosnips
