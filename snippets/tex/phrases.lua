local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local reference_snippet_table = {
	a = "auto",
	c = "c",
	C = "C",
	e = "eq",
	r = "",
}

local opts = { condition = tex.in_text, show_condition = tex.in_text }
local opts2 = {
	condition = conds_expand.line_begin * tex.in_text,
	show_condition = pos.line_begin * tex.in_text,
}

local function phrase_snippet(trig, body)
	return s({ trig = trig, desc = trig }, t(body), opts)
end

snips = {
	s(
		{
			trig = "cf",
			name = "cross refrence",
			condition = tex.in_text,
			show_condition = tex.in_text,
		},
		fmta([[\cite[<>]{<>}<>]], { i(1), i(2), i(0) }),
		{
			callbacks = {
				[2] = {
					[events.enter] = function()
						require("telescope").extensions.bibtex.bibtex(
							require("telescope.themes").get_dropdown({ previewer = false })
						)
					end,
				},
			},
		}
	),
}

autosnips = {
	s({ trig = "qf", name = "Q-factorial" }, { t("\\(\\mathbb{Q}\\)-factorial") }, opts),
	s({ trig = "bqf", name = "base point free" }, { t("base point free") }, opts),

	s(
		{
			trig = "([acC])ref",
			name = "(acC)?ref",
			desc = "add a reference (with autoref, cref)",
			trigEngine = "pattern",
			hidden = true,
		},
		fmta(
			[[\<>ref{<>}<>]],
			{ f(function(_, snip)
				return reference_snippet_table[snip.captures[1]]
			end), i(1), i(0) }
		),
		opts
	),

	s(
		{ trig = "eqref", desc = "add a reference with eqref", trigEngine = "pattern", hidden = true },
		fmta([[\eqref{eq:<>}<>]], { i(1), i(0) }),
		{
			condition = tex.in_text,
			show_condition = tex.in_text,
			callbacks = {
				[1] = {
					[events.enter] = function()
						require("cmp").complete()
					end,
				},
			},
		}
	),

	s({
		trig = "Tfae",
		name = "The following are equivalent",
	}, { t("The following are equivalent") }, opts2),

	s({
		trig = "([wW])log",
		name = "without loss of generality",
		trigEngine = "pattern",
	}, {
		f(function(_, snip)
			return snip.captures[1] .. "ithout loss of generality"
		end, {}),
	}, opts2),

	s({ trig = "([qr])c", name = "Cartier", trigEngine = "pattern" }, {
		f(function(_, snip)
			return "\\(\\mathbb{" .. string.upper(snip.captures[1]) .. "}\\)-Cartier"
		end, {}),
	}, opts),
	s({ trig = "([qr])d", name = "divisor", trigEngine = "pattern" }, {
		f(function(_, snip)
			return "\\(\\mathbb{" .. string.upper(snip.captures[1]) .. "}\\)-divisor"
		end, {}),
	}, opts),
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
	ggg = "generically globally generated",
	fgd = "finitely generated",
	mfs = "Mori fibre space",
	snc = "simple normal crossing",
	lmm = "log minimal model",
	tfae = "the following are equivalent",
}

for k, v in pairs(phrase_specs) do
	table.insert(snips, phrase_snippet(k, v))
end
for k, v in pairs(auto_phrase_specs) do
	table.insert(autosnips, phrase_snippet(k, v))
end

return snips, autosnips
