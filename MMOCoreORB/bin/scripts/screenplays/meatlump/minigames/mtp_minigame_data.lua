--[[
	Meatlump puzzle data for the four pages this client does not draw.

	ruling 2026-09-05: "ensuring meatlump ... done"

	OPEN: /Script.sliceTerminal, /Script.questionnaire, /Script.disarmBomb
	do not ship. Task logic and tables live here so a later page has
	nothing missing. evaluate* functions take the player's answer and
	return the java outcome. No SUI page is opened from this file.

	Sources: datatables/theme_park/meatlump_threshold.tab,
	meatlump_safe_passwords.tab, meatlump_target_map_text.tab,
	script/theme_park/meatlump/{code_break_minigame,slicing_minigame,
	target_map_puzzle,disarm_bomb_puzzle}.java
]]

MtpMinigameData = {}

-- meatlump_threshold.tab rows 3-6 (header line 1, types line 2)
MtpMinigameData.thresholds = {
	[3] = { 18, 10, 5, 0, 0, 0 }, -- tab line 3 combinations=3
	[4] = { 20, 12, 7, 5, 0, 0 }, -- tab line 4 combinations=4
	[5] = { 22, 14, 9, 7, 5, 0 }, -- tab line 5 combinations=5
	[6] = { 24, 16, 11, 9, 7, 5 }, -- tab line 6 combinations=6
}

MtpMinigameData.MAX_INT_COMBO = { 10000, 5000, 2000, 1000, 500, 100 } -- code_break_minigame.java:39-45
MtpMinigameData.BUFF_COMBO_AMOUNT = 3 -- code_break_minigame.java:38

-- meatlump_safe_passwords.tab; anagram columns that were non-empty
MtpMinigameData.passwords = {
	{ row = 3, password = "alderaangone", pointsNeeded = 10, threshold = 6, anagrams = { "role", "done", "rode", "lade", "roan", "road", "rend", "reel", "reed", "redo", "deer", "real", "read", "rang", "rand", "dare", "rage", "raga", "area", "edge", "anon", "oral", "anal", "aloe", "alga", "ogre", "ogle", "aged", "dole", "agar", "none", "noel", "node", "geed", "nerd", "neon", "need", "deal", "near", "earn", "dang", "lorn", "lore", "lord", "long", "lone", "loge", "darn", "lode", "loan", "load", "lend", "goad", "leer", "aeon", "dean", "lean", "lead", "gale", "lard", "lane", "land", "doge", "gaol", "doer", "grad", "gore", "gone", "gold", "goer", "dona", "goal", "elan", "glen", "glee", "glad", "gene", "geld", "dong", "dear", "earl", "gear", "drag", "dale", "ergo", "gala", "egad", "leg", "gel", "gad", "gal", "era", "erg", "end", "rod", "ego", "lea", "eel", "rad", "nag", "gee", "ear", "log", "eon", "roe", "ere", "don", "oar", "lag", "dog", "lad", "doe", "den", "red", "nod", "led", "nee", "gar", "ran", "nae", "god", "rag", "are", "ore", "and", "one", "ole", "old", "ale", "ago", "ode", "age", "nor", "lee", "ado" } },
	{ row = 4, password = "alliance", pointsNeeded = 7, threshold = 3, anagrams = { "call", "nice", "nail", "cell", "line", "lien", "acne", "lice", "anal", "lean", "clan", "lane", "lain", "lace", "elan", "cane", "ilea", "ice", "ell", "lac", "lea", "nae", "ill", "can", "nil", "ani", "lei", "all", "ale", "ail", "lie", "ace" } },
	{ row = 5, password = "alliancerebel", pointsNeeded = 11, threshold = 7, anagrams = { "rill", "rile", "rice", "bane", "rial", "rein", "reel", "bail", "real", "rani", "area", "rain", "rail", "race", "anal", "nice", "bear", "bean", "near", "narc", "nail", "acne", "cell", "lire", "lira", "line", "lien", "beer", "lice", "brie", "liar", "brae", "leer", "bare", "lean", "bani", "lane", "lair", "lain", "lace", "cane", "clan", "able", "barn", "ilea", "bier", "bell", "call", "been", "elan", "bale", "earn", "earl", "acre", "crib", "crab", "ball", "aria", "care", "bile", "bran", "bill", "lac", "cab", "lab", "era", "lei", "bra", "nab", "can", "car", "ice", "ere", "lie", "ell", "bee", "nib", "nee", "ill", "lee", "bar", "lea", "rib", "ban", "lib", "eel", "rec", "baa", "bin", "ran", "are", "arc", "ani", "nil", "all", "ale", "alb", "air", "ail", "ear", "nae", "ace", "ire" } },
	{ row = 6, password = "alwaysremember", pointsNeeded = 13, threshold = 9, anagrams = { "yews", "berm", "bees", "yeas", "year", "bear", "yaws", "yawl", "eras", "yams", "base", "bars", "were", "wees", "weer", "bale", "webs", "easy", "wear", "weal", "ways", "awls", "byes", "wary", "wars", "warm", "ware", "arms", "wale", "sway", "swam", "swab", "alms", "slew", "slay", "slaw", "slam", "slab", "aery", "sere", "sera", "seer", "seem", "ease", "sear", "seam", "seal", "ewer", "baas", "errs", "same", "sale", "ryes", "brae", "lamb", "rems", "beys", "rely", "reel", "rear", "ream", "real", "rays", "beam", "raws", "ales", "rare", "rams", "labs", "mews", "mewl", "balm", "mesa", "mere", "meal", "mays", "laws", "maws", "ears", "beer", "mars", "marl", "mare", "army", "mama", "male", "lyre", "lyes", "bare", "lees", "leer", "elms", "leas", "eery", "lays", "brew", "awry", "ably", "able", "lams", "lame", "albs", "lama", "bras", "earl", "ares", "eyes", "bawl", "ewes", "ayes", "bays", "area", "bray", "alas", "awes", "eels", "away", "else", "blew", "lam", "lea", "ram", "eel", "web", "see", "may", "era", "eye", "was", "bye", "elm", "lay", "err", "lee", "rye", "bra", "ewe", "res", "bey", "yew", "yes", "brr", "bee", "yea", "ray", "maw", "bay", "ear", "yam", "wry", "lye", "bar", "mew", "wee", "say", "baa", "sea", "aye", "saw", "way", "awl", "yaw", "awe", "ems", "mar", "war", "arm", "lab", "mas", "are", "sly", "raw", "ale", "rem", "alb", "ere", "sew", "abs", "law", "las" } },
	{ row = 7, password = "bageraset", pointsNeeded = 11, threshold = 7, anagrams = { "tsar", "tree", "tees", "bate", "teas", "tear", "base", "tars", "tare", "beta", "tags", "best", "tabs", "begs", "star", "stag", "stab", "ares", "sere", "sera", "seer", "bats", "seat", "sear", "abet", "sate", "bars", "sage", "saga", "bags", "rest", "baas", "rats", "rate", "arts", "rags", "rage", "raga", "eras", "grab", "gets", "agar", "gees", "bees", "gear", "gate", "beat", "gars", "garb", "brae", "gabs", "bast", "etas", "beer", "erst", "ergs", "bear", "brag", "area", "bare", "eats", "bras", "east", "ease", "ears", "bets", "brat", "beet", "ages", "berg", "eat", "ear", "tar", "rag", "ere", "gar", "tab", "beg", "era", "gee", "eta", "bee", "tag", "erg", "see", "tee", "bat", "gab", "tea", "sat", "bra", "bar", "sag", "bag", "res", "baa", "ate", "rat", "art", "set", "bet", "are", "gas", "age", "get", "abs", "sea" } },
	{ row = 8, password = "blastem", pointsNeeded = 10, threshold = 6, anagrams = { "teas", "team", "teal", "bats", "tams", "tame", "bast", "tale", "tabs", "bale", "stem", "stab", "slat", "slam", "slab", "belt", "seat", "seam", "seal", "bate", "sate", "ales", "same", "salt", "sale", "lams", "mesa", "melt", "meat", "meal", "mats", "mate", "able", "mast", "base", "malt", "male", "lets", "alms", "lest", "leas", "albs", "late", "last", "balm", "beta", "lame", "lamb", "bets", "labs", "beam", "etas", "east", "beat", "elms", "abet", "eats", "best", "eat", "sat", "met", "elm", "eta", "set", "ems", "lab", "tea", "sea", "bat", "tam", "mas", "las", "tab", "ate", "let", "lam", "ale", "lea", "alb", "abs", "mat", "bet" } },
	{ row = 9, password = "blissltuner", pointsNeeded = 13, threshold = 9, anagrams = { "uses", "user", "nest", "urns", "lust", "unit", "turn", "tuns", "tune", "list", "tubs", "tube", "line", "burn", "tire", "tins", "tine", "buns", "till", "tile", "ties", "tier", "blue", "tern", "tens", "leis", "tell", "sure", "suns", "bill", "suit", "suet", "sues", "lire", "subs", "bent", "stun", "stub", "stir", "snub", "snit", "slur", "slue", "slit", "sits", "site", "lent", "lens", "sirs", "sire", "blur", "sins", "sine", "bite", "silt", "sill", "sets", "erst", "sent", "sell", "ruts", "bets", "rust", "ruse", "runt", "runs", "rune", "burl", "rule", "ruin", "rues", "bile", "rubs", "rube", "lets", "rite", "rise", "rill", "rile", "ribs", "bins", "rest", "bull", "rent", "rein", "nuts", "lilt", "best", "null", "nubs", "bell", "nits", "nite", "lieu", "nils", "buss", "nibs", "burs", "nets", "brie", "bust", "lute", "bier", "lure", "lube", "lite", "ills", "belt", "bits", "lint", "ells", "less", "bunt", "lies", "lien", "lest", "libs", "isle", "ires", "use", "res", "nut", "sit", "sis", "net", "lei", "nit", "lib", "rub", "ire", "ins", "lit", "ill", "set", "ens", "tub", "ell", "but", "let", "nil", "bus", "nib", "tis", "run", "bur", "its", "tin", "bun", "rue", "ten", "sir", "tie", "sue", "sin", "bit", "bis", "rib", "bin", "sun", "lie", "urn", "rut", "bet", "nus", "sub", "tun", "nub" } },
	{ row = 10, password = "blowedup", pointsNeeded = 7, threshold = 3, anagrams = { "wold", "bowl", "weld", "lode", "bole", "pule", "bode", "pole", "blue", "blow", "plow", "plod", "pled", "dope", "dole", "owed", "duel", "oped", "lobe", "dupe", "blew", "bled", "lube", "bold", "loud", "lope", "lewd", "lop", "ope", "lob", "wed", "led", "ole", "duo", "owe", "due", "dub", "pew", "owl", "doe", "dew", "deb", "bud", "woe", "bow", "bop", "web", "low", "pub", "bod", "pol", "pod", "old", "ode", "bed" } },
	{ row = 11, password = "canoid", pointsNeeded = 5, threshold = 1, anagrams = { "dona", "ciao", "icon", "coin", "acid", "coda", "nod", "con", "doc", "din", "cod", "ion", "can", "cad", "ani", "and", "aid", "ado", "don" } },
	{ row = 12, password = "captain", pointsNeeded = 6, threshold = 2, anagrams = { "cant", "pint", "pain", "anti", "pant", "pita", "pact", "pica", "tan", "tin", "pic", "pat", "pin", "pan", "tic", "pit", "nit", "nip", "nap", "cat", "cap", "tip", "can", "apt", "tap", "ant", "ani", "act" } },
	{ row = 13, password = "captainsstash", pointsNeeded = 10, threshold = 6, anagrams = { "pain", "haps", "tips", "chit", "tint", "tins", "chin", "tics", "chat", "this", "thin", "that", "than", "tats", "caps", "taps", "cant", "tans", "hips", "tact", "stat", "spit", "spin", "spat", "spas", "span", "naps", "snit", "snip", "snap", "sits", "inch", "hits", "sips", "chap", "sins", "pats", "sics", "cash", "ship", "shin", "shat", "scat", "scan", "asps", "sass", "sash", "saps", "ants", "sans", "sacs", "pans", "psst", "psis", "hats", "pits", "pith", "pita", "cans", "pint", "pins", "chip", "pics", "pica", "cast", "phis", "anti", "phat", "itch", "path", "acts", "past", "pass", "hiss", "pant", "chis", "hint", "cats", "pact", "hast", "nits", "hasp", "hist", "nip", "sin", "pic", "sac", "pan", "ins", "sit", "sis", "hit", "spa", "pas", "his", "tan", "hip", "pit", "psi", "hat", "nap", "nit", "has", "tis", "hap", "tip", "its", "pin", "tin", "chi", "tic", "sip", "cat", "nth", "sic", "tat", "cap", "tap", "pis", "can", "sat", "asp", "ash", "apt", "sap", "phi", "ant", "ani", "aha", "pat", "act" } },
	{ row = 14, password = "changeme", pointsNeeded = 7, threshold = 3, anagrams = { "mace", "name", "amen", "ahem", "cane", "mega", "mean", "mane", "cage", "came", "mach", "gene", "acne", "acme", "heme", "ache", "hang", "each", "game", "mag", "gem", "gee", "nee", "ham", "men", "can", "hag", "cam", "man", "nag", "nae", "age", "mac", "hen", "hem", "ace" } },
	{ row = 15, password = "changemesoon", pointsNeeded = 12, threshold = 8, anagrams = { "soon", "song", "coos", "some", "snag", "smog", "shoo", "shoe", "come", "sham", "shag", "seen", "seem", "cash", "case", "seam", "cane", "scan", "scam", "sang", "sane", "same", "sago", "sage", "amen", "ahem", "oohs", "ages", "ones", "aeon", "once", "acme", "omen", "aces", "heme", "ohms", "coma", "nosh", "nose", "game", "noon", "none", "noes", "neon", "egos", "name", "nags", "ease", "cage", "mosh", "moos", "moon", "hags", "mono", "moan", "mesh", "mesa", "acne", "mega", "mean", "mash", "gems", "mans", "mane", "each", "mags", "cams", "macs", "mach", "mace", "cone", "hose", "goos", "hons", "hone", "cogs", "home", "hogs", "cans", "hoes", "cons", "gash", "hens", "echo", "hems", "coho", "anon", "ache", "hang", "hams", "eons", "gees", "gosh", "came", "goon", "gene", "gone", "goes", "goo", "mas", "moo", "hag", "gee", "hes", "gas", "nos", "ham", "eon", "ens", "ems", "hos", "ego", "hen", "nag", "man", "cos", "has", "gem", "coo", "hoe", "mac", "con", "she", "ohm", "oho", "hon", "cog", "see", "sec", "hog", "sea", "can", "mag", "nee", "cam", "nae", "ash", "hem", "sag", "sac", "ago", "ooh", "age", "one", "men", "oms", "son", "ohs", "ace" } },
	{ row = 16, password = "combination", pointsNeeded = 8, threshold = 4, anagrams = { "boom", "comb", "tomb", "coin", "mica", "coat", "ciao", "main", "taco", "onto", "omit", "obit", "boon", "anon", "bani", "noon", "bait", "mini", "cant", "iamb", "moot", "moon", "boot", "mono", "atom", "moat", "moan", "mint", "into", "anti", "coot", "coma", "boat", "icon", "iota", "mac", "nib", "inn", "ion", "mot", "tam", "mat", "nit", "coo", "tin", "ton", "man", "tom", "cob", "tic", "tan", "cat", "nab", "can", "cam", "cab", "moo", "obi", "too", "boo", "not", "boa", "bit", "bio", "bin", "bat", "cot", "ban", "tab", "mob", "con", "ant", "oat", "ani", "aim", "act" } },
	{ row = 17, password = "computer", pointsNeeded = 8, threshold = 4, anagrams = { "cute", "tour", "tore", "moue", "mote", "tome", "more", "crop", "term", "temp", "euro", "rump", "core", "cope", "rout", "roue", "rote", "mope", "rope", "romp", "mute", "come", "coup", "cote", "corm", "pure", "puce", "prom", "perm", "pout", "pour", "cure", "port", "pore", "poet", "poem", "ecru", "pert", "curt", "comp", "rep", "pro", "ore", "put", "our", "pot", "tor", "top", "mot", "tom", "rot", "mop", "met", "rut", "emu", "pet", "ump", "cut", "ope", "roe", "cur", "cup", "cue", "toe", "rem", "rec", "cot", "opt", "rum", "rue", "cop", "per", "out" } },
	{ row = 18, password = "corellia", pointsNeeded = 7, threshold = 3, anagrams = { "roll", "role", "roil", "call", "rill", "rile", "rice", "rial", "coal", "real", "rail", "race", "care", "oral", "cola", "coil", "aloe", "lore", "loci", "lire", "lira", "acre", "lice", "liar", "cell", "earl", "lair", "lace", "ciao", "ilea", "core", "ire", "ice", "era", "ell", "ore", "ear", "ill", "ole", "oil", "rec", "lac", "lei", "lea", "car", "roe", "are", "arc", "oar", "all", "ale", "air", "ail", "lie", "ace" } },
	{ row = 19, password = "corelliahome", pointsNeeded = 13, threshold = 9, anagrams = { "room", "roll", "role", "roil", "come", "roam", "rime", "coil", "rill", "rile", "rich", "rice", "rial", "char", "rhea", "care", "reel", "came", "ream", "real", "call", "rail", "here", "race", "echo", "oral", "aloe", "oleo", "cram", "corm", "core", "cool", "ahem", "more", "moor", "ache", "moll", "mole", "moil", "mire", "mill", "mile", "emir", "mice", "mica", "mere", "meal", "marl", "mare", "each", "mall", "male", "mail", "mach", "mace", "hair", "lore", "loom", "loco", "loci", "loch", "loam", "lire", "lira", "limo", "lime", "hall", "lice", "liar", "hail", "leer", "heal", "lech", "coma", "lame", "halo", "lair", "lace", "clam", "ciao", "harm", "ilea", "cell", "hora", "home", "hole", "hoer", "amir", "hire", "coal", "hill", "calm", "hero", "coho", "earl", "heme", "cola", "helm", "heir", "heel", "hear", "acme", "arch", "hare", "hale", "acre", "lee", "hoe", "hie", "lei", "ere", "era", "rah", "lie", "ell", "eel", "ore", "her", "ear", "mar", "ill", "oil", "oho", "ohm", "coo", "roe", "lea", "hem", "rim", "lam", "him", "lac", "ire", "chi", "rho", "ice", "rem", "car", "rec", "cam", "mac", "ram", "arm", "are", "ole", "arc", "ham", "ooh", "all", "ale", "air", "aim", "ail", "oar", "mil", "elm", "moo", "ace" } },
	{ row = 20, password = "coronet", pointsNeeded = 5, threshold = 1, anagrams = { "torn", "tore", "coot", "tone", "cone", "corn", "tern", "note", "rote", "once", "root", "core", "rent", "cent", "cote", "onto", "one", "ore", "ten", "not", "nor", "rec", "eon", "rot", "cot", "toe", "roe", "tor", "too", "coo", "ton", "con", "net" } },
	{ row = 21, password = "coronethome", pointsNeeded = 11, threshold = 7, anagrams = { "tree", "torn", "tore", "heme", "mere", "tone", "meet", "tome", "echo", "cote", "hone", "then", "them", "thee", "coot", "tern", "term", "cone", "teen", "teem", "coho", "tech", "rote", "moth", "root", "room", "home", "hoer", "rent", "corm", "core", "horn", "onto", "moot", "once", "omen", "more", "cent", "hero", "note", "corn", "norm", "morn", "etch", "hoot", "mote", "here", "moor", "mono", "mete", "come", "moon", "net", "oho", "one", "met", "too", "moo", "ton", "hot", "ore", "rot", "tho", "hon", "nor", "roe", "rho", "hoe", "nth", "mot", "her", "hen", "tor", "hem", "nee", "ere", "eon", "tom", "toe", "cot", "not", "rem", "rec", "the", "ooh", "coo", "ten", "con", "men", "tee", "ohm" } },
	{ row = 22, password = "corsecpoodoo", pointsNeeded = 7, threshold = 3, anagrams = { "sped", "spec", "sore", "core", "cord", "cops", "rose", "rope", "rood", "roes", "odes", "rods", "rode", "code", "dose", "reps", "dope", "reds", "redo", "doer", "recs", "coop", "pros", "prod", "cods", "pose", "pore", "poor", "pods", "odor", "peso", "does", "ores", "coed", "docs", "opes", "oped", "coco", "oops", "door", "crop", "cope", "drop", "coos", "pod", "res", "rep", "eds", "per", "red", "dos", "ops", "doc", "roe", "cos", "sop", "sod", "sec", "ode", "cop", "doe", "rec", "coo", "ore", "pro", "rod", "cod", "ope" } },
	{ row = 23, password = "destroydroids", pointsNeeded = 11, threshold = 7, anagrams = { "yore", "yeti", "dyer", "dyed", "tyro", "tyre", "roes", "troy", "trod", "trio", "trey", "toys", "rise", "toss", "tors", "tore", "doer", "erst", "toes", "toed", "redo", "dirt", "tiro", "tire", "ties", "tier", "tied", "dido", "tidy", "tide", "stye", "dire", "stir", "soys", "died", "sots", "door", "does", "sort", "sore", "soot", "sods", "reds", "sits", "site", "diet", "dies", "sirs", "sire", "dost", "side", "sets", "dory", "ryes", "rest", "rots", "rote", "dodo", "rosy", "rose", "root", "rood", "eddy", "dose", "rods", "rode", "errs", "rite", "dyes", "riot", "rids", "ride", "ires", "odds", "dote", "drys", "diss", "dots", "ores", "ides", "odor", "odes", "edit", "rye", "sty", "its", "rid", "toy", "ids", "ore", "too", "rod", "err", "eds", "ire", "toe", "ode", "yet", "yes", "dye", "sod", "dry", "soy", "odd", "dot", "sir", "roe", "dos", "set", "sot", "sos", "tor", "doe", "rot", "try", "dis", "tis", "res", "sit", "sis", "red", "die", "tie", "did" } },
	{ row = 24, password = "diedroidsdie", pointsNeeded = 7, threshold = 3, anagrams = { "sore", "doer", "sire", "odes", "side", "sere", "seer", "seed", "dido", "rose", "roes", "deed", "rods", "rode", "dies", "rise", "rids", "ride", "ires", "deer", "reed", "reds", "redo", "iris", "ores", "died", "dire", "dose", "odds", "does", "ides", "red", "ore", "ids", "rid", "ere", "eds", "ode", "dos", "odd", "sod", "doe", "dis", "sir", "rod", "ire", "die", "see", "did", "res", "roe" } },
	{ row = 25, password = "dontforget", pointsNeeded = 11, threshold = 7, anagrams = { "trot", "trod", "tote", "ergo", "tort", "torn", "tore", "fore", "toot", "good", "tong", "tone", "done", "fond", "toed", "gent", "tern", "tent", "tend", "fort", "rote", "ford", "root", "roof", "rood", "dote", "rode", "door", "rent", "rend", "fend", "redo", "goof", "doer", "onto", "dent", "ogre", "deft", "odor", "fern", "note", "dong", "food", "node", "doge", "nett", "fret", "nerd", "font", "gore", "goon", "gone", "foot", "frog", "goer", "net", "goo", "get", "got", "god", "fro", "red", "ten", "tor", "rot", "for", "too", "nor", "toe", "tog", "fog", "foe", "ode", "ref", "fen", "fed", "tot", "erg", "eon", "end", "ego", "roe", "dot", "rod", "not", "ton", "don", "nod", "dog", "ore", "doe", "one", "den", "oft", "def" } },
	{ row = 26, password = "droidhater", pointsNeeded = 11, threshold = 7, anagrams = { "trod", "trio", "tore", "hear", "toed", "dire", "toad", "tiro", "tire", "tier", "tied", "dear", "tide", "date", "dart", "tear", "dado", "taro", "tare", "doth", "arid", "rote", "hied", "aide", "rode", "dirt", "roar", "road", "rite", "riot", "ride", "edit", "head", "rhea", "redo", "hart", "rear", "read", "rate", "doer", "rare", "raid", "hate", "diet", "died", "hare", "dido", "oath", "dote", "dead", "hide", "iota", "idea", "hard", "hora", "hoer", "hoed", "hair", "heir", "heat", "hire", "herd", "drat", "hero", "dare", "ire", "rot", "hoe", "hod", "hit", "tor", "rho", "rah", "hat", "red", "ode", "hot", "her", "had", "eta", "err", "era", "rid", "eat", "ear", "hie", "tar", "oat", "dot", "doh", "rat", "doe", "rod", "toe", "rad", "ore", "die", "odd", "did", "tie", "oar", "tho", "the", "hid", "tea", "dad", "ate", "art", "tad", "are", "air", "roe", "aid", "ado", "add" } },
	{ row = 27, password = "explosives", pointsNeeded = 11, threshold = 7, anagrams = { "live", "vole", "vise", "viol", "vile", "vies", "less", "leis", "veil", "veep", "loss", "isle", "sops", "exes", "sols", "soli", "sole", "else", "soil", "slop", "sloe", "slip", "evil", "lose", "sips", "lope", "silo", "expo", "sees", "seep", "eves", "psis", "oles", "eels", "pose", "pols", "pole", "lisp", "pois", "oils", "lies", "love", "pile", "pies", "lees", "peso", "pees", "peel", "lops", "lips", "opes", "ope", "psi", "ole", "poi", "oil", "lox", "pis", "sox", "sis", "sip", "lop", "xis", "pol", "six", "lip", "pix", "lie", "vie", "vex", "lei", "pie", "lee", "sos", "sex", "sop", "ops", "see", "eve", "sol", "pox", "eel" } },
	{ row = 28, password = "fambaaraces", pointsNeeded = 8, threshold = 4, anagrams = { "serf", "sera", "bare", "sear", "seam", "cafe", "scar", "scam", "scab", "same", "safe", "arcs", "bear", "rems", "acre", "refs", "aces", "recs", "case", "ream", "rams", "arms", "race", "mesa", "area", "mars", "mare", "barf", "macs", "mace", "acme", "fear", "care", "farm", "fare", "bars", "fame", "face", "eras", "afar", "beam", "ears", "cabs", "cram", "crab", "brae", "cars", "berm", "ares", "cams", "came", "baas", "bras", "base", "cab", "sea", "rec", "bra", "fas", "car", "ems", "ear", "far", "mar", "sec", "bar", "cam", "baa", "ram", "arm", "res", "mas", "are", "sac", "arc", "era", "rem", "mac", "ref", "ace", "abs" } },
	{ row = 29, password = "gangster", pointsNeeded = 11, threshold = 7, anagrams = { "tsar", "tern", "tens", "eggs", "teas", "tear", "neat", "tars", "tarn", "tare", "rags", "tans", "tang", "erst", "tags", "gear", "star", "stag", "snag", "ages", "sera", "sent", "seat", "sear", "ears", "sate", "gate", "sang", "sane", "sage", "ares", "rest", "ants", "rent", "rats", "rate", "east", "rant", "rang", "eras", "ante", "rage", "earn", "nets", "eats", "nest", "gang", "near", "nags", "gage", "ergs", "gnat", "gets", "gars", "gent", "etas", "gags", "arts", "rag", "gar", "tea", "sat", "nag", "get", "gas", "eta", "tan", "nae", "tar", "ran", "era", "ens", "ten", "egg", "net", "eat", "rat", "sea", "tag", "ear", "ate", "erg", "art", "sag", "are", "res", "gag", "ant", "set", "age" } },
	{ row = 30, password = "gunganhater", pointsNeeded = 11, threshold = 7, anagrams = { "rate", "urge", "urea", "gaga", "turn", "tune", "tuna", "hang", "hunt", "thug", "thru", "then", "aunt", "than", "tern", "area", "tear", "ante", "gang", "tarn", "tare", "neat", "tang", "gear", "gage", "gnat", "runt", "rung", "rune", "aura", "gate", "ghat", "rhea", "rent", "heat", "hear", "rant", "rang", "ague", "gent", "rage", "raga", "hate", "hung", "agar", "hare", "hurt", "earn", "near", "hart", "huge", "nae", "rue", "tug", "nut", "hut", "hug", "hue", "her", "tag", "urn", "rat", "rag", "hat", "tan", "nth", "tun", "tar", "gut", "gun", "gnu", "rut", "net", "get", "hen", "nag", "rug", "gar", "tau", "nun", "ugh", "gag", "eta", "erg", "era", "egg", "eat", "hag", "ear", "run", "the", "ate", "art", "ten", "are", "tea", "ant", "aha", "ran", "age", "rah" } },
	{ row = 31, password = "gurrcat", pointsNeeded = 5, threshold = 1, anagrams = { "cart", "curt", "crag", "tau", "rut", "rug", "rat", "rag", "gut", "gar", "cut", "tag", "cur", "tar", "cat", "tug", "car", "art", "arc", "act" } },
	{ row = 32, password = "hiddendaggers", pointsNeeded = 13, threshold = 9, anagrams = { "snag", "sire", "dire", "sing", "sine", "dine", "sign", "sigh", "side", "shin", "shed", "gage", "shag", "shad", "sere", "sera", "send", "seer", "seen", "seed", "dash", "sear", "dare", "sari", "sang", "sane", "sand", "said", "sage", "ares", "ears", "rise", "ring", "rind", "rigs", "aids", "rids", "ride", "ages", "rhea", "gird", "rend", "rein", "reed", "reds", "gene", "read", "rash", "rani", "rang", "rand", "dear", "rain", "raid", "edge", "rags", "rage", "dang", "rads", "dads", "nigh", "nerd", "need", "dins", "near", "nags", "grad", "airs", "ires", "dies", "aide", "gags", "ides", "idea", "gads", "hire", "hind", "hies", "hied", "dead", "hide", "darn", "ends", "hers", "here", "herd", "gash", "hens", "arid", "heir", "heed", "hear", "head", "dens", "hare", "hard", "hang", "hand", "hair", "hags", "eras", "deed", "grin", "grid", "ergs", "died", "gins", "dish", "gigs", "dais", "deer", "gees", "geed", "dean", "gear", "egad", "drag", "gars", "ease", "gang", "gain", "digs", "adds", "eggs", "aged", "egis", "earn", "ding", "gas", "hag", "ids", "gig", "hes", "end", "gad", "had", "egg", "her", "eds", "rah", "gar", "sad", "nag", "ear", "ere", "gin", "his", "sir", "nee", "erg", "sin", "din", "era", "dig", "ire", "res", "die", "did", "has", "den", "red", "gag", "ran", "gee", "hie", "see", "hid", "sea", "rag", "ens", "rad", "dad", "ash", "hen", "sag", "are", "ani", "and", "nae", "air", "rig", "ins", "aid", "rid", "dis", "age", "ads", "she", "add" } },
	{ row = 33, password = "ilikefood", pointsNeeded = 7, threshold = 3, anagrams = { "oleo", "fold", "foil", "idle", "dole", "look", "lode", "like", "life", "lief", "lied", "fled", "lido", "dike", "floe", "deli", "kilo", "food", "folk", "idol", "file", "fool", "oil", "ilk", "kid", "old", "foe", "lei", "lie", "ole", "fie", "fed", "elk", "elf", "ode", "doe", "lid", "die", "led", "def" } },
	{ row = 34, password = "imperial", pointsNeeded = 10, threshold = 6, anagrams = { "ripe", "ilia", "rime", "marl", "rile", "rial", "earl", "male", "reap", "ream", "real", "amir", "ramp", "mire", "rail", "prim", "pram", "plea", "pile", "pier", "lame", "perm", "lair", "pear", "peal", "leap", "pare", "lime", "palm", "pale", "mare", "pair", "pail", "lira", "mile", "ilea", "meal", "emir", "mail", "lamp", "limp", "liar", "lire", "pal", "ram", "lip", "map", "par", "lie", "rem", "lei", "pea", "lea", "lap", "mar", "pie", "lam", "per", "ire", "imp", "rip", "mil", "era", "rim", "elm", "rep", "ear", "arm", "are", "ape", "amp", "rap", "alp", "ale", "air", "aim", "ail" } },
	{ row = 35, password = "imperials", pointsNeeded = 13, threshold = 9, anagrams = { "spar", "lira", "slip", "slim", "slap", "slam", "sire", "emir", "elms", "sera", "semi", "sear", "seam", "seal", "arms", "sari", "ares", "same", "sale", "sail", "rise", "rips", "ripe", "amir", "rims", "rime", "alms", "rile", "rial", "airs", "reps", "aims", "rems", "ails", "reap", "ream", "real", "rasp", "raps", "lame", "rams", "ramp", "lies", "rail", "apse", "prim", "pram", "plea", "leap", "pile", "pies", "pier", "limp", "perm", "lamp", "peas", "pear", "peal", "earl", "isle", "pars", "pare", "lime", "pals", "palm", "pale", "apes", "pair", "pail", "lair", "mire", "mils", "mile", "ears", "mesa", "meal", "lips", "mars", "marl", "mare", "ales", "maps", "ires", "male", "mail", "lisp", "lire", "alps", "leas", "laps", "amps", "imps", "iris", "ilia", "liar", "leis", "ilea", "lams", "eras", "ram", "pie", "lip", "mar", "mas", "per", "lea", "lam", "mis", "ism", "pas", "pis", "map", "ire", "par", "imp", "lie", "las", "rap", "era", "ems", "sir", "sip", "elm", "mil", "pea", "ear", "asp", "sea", "arm", "sap", "are", "psi", "pal", "ape", "lei", "amp", "rip", "spa", "alp", "rim", "lap", "ale", "res", "air", "rep", "aim", "rem", "ail" } },
	{ row = 36, password = "killtheking", pointsNeeded = 8, threshold = 4, anagrams = { "ting", "tine", "hike", "till", "tile", "tike", "glen", "thin", "then", "gill", "kilt", "tell", "gelt", "nite", "king", "kine", "nigh", "lite", "kill", "lint", "link", "ling", "line", "lilt", "like", "lien", "hint", "hilt", "lent", "kent", "kiln", "knit", "kith", "kite", "hill", "kink", "gilt", "gent", "nil", "ten", "leg", "nit", "lei", "ken", "keg", "ink", "ill", "ilk", "hit", "lie", "let", "kit", "tin", "hie", "hen", "net", "tie", "gin", "lit", "the", "get", "kin", "nth", "gel", "ell", "elk" } },
	{ row = 37, password = "legwraps", pointsNeeded = 11, threshold = 7, anagrams = { "wrap", "wear", "weal", "wasp", "ergs", "wars", "warp", "ware", "ears", "wale", "wags", "wage", "gels", "swap", "swag", "spew", "spar", "gars", "slew", "slaw", "slap", "slag", "gals", "sera", "sear", "seal", "page", "eras", "apes", "sale", "sage", "gasp", "awls", "reps", "awes", "reap", "real", "raws", "pare", "rasp", "raps", "alps", "rags", "rage", "laps", "plea", "pews", "gape", "grew", "pegs", "gale", "peas", "pear", "peal", "apse", "paws", "pawl", "earl", "gear", "pars", "gaps", "ages", "pals", "pale", "ares", "ales", "legs", "lags", "leas", "leap", "laws", "sap", "law", "lea", "rag", "lap", "raw", "lag", "per", "wag", "gel", "pas", "sag", "gas", "spa", "gar", "las", "pew", "sea", "sew", "peg", "gal", "was", "erg", "saw", "era", "war", "paw", "ear", "res", "awl", "rep", "awe", "asp", "pal", "are", "pea", "leg", "ape", "rap", "alp", "gap", "ale", "par", "age" } },
	{ row = 38, password = "letmein", pointsNeeded = 6, threshold = 2, anagrams = { "tine", "meet", "time", "tile", "lint", "line", "teen", "teem", "lien", "nite", "mien", "lent", "limn", "lime", "mite", "mint", "mine", "milt", "mile", "emit", "item", "mete", "melt", "lite", "met", "nit", "men", "lit", "tie", "mil", "net", "nee", "tee", "lie", "let", "nil", "lei", "lee", "tin", "ten", "elm", "eel" } },
	{ row = 39, password = "lordnyax", pointsNeeded = 9, threshold = 5, anagrams = { "dray", "yarn", "yard", "lard", "roan", "road", "axon", "rand", "lorn", "dory", "oral", "onyx", "only", "darn", "load", "land", "dona", "lord", "nary", "lynx", "loan", "lady", "nay", "lox", "ran", "lay", "lax", "rod", "nor", "oar", "lad", "dry", "yon", "rad", "nod", "don", "day", "old", "ray", "any", "and", "ado" } },
	{ row = 40, password = "meatlump", pointsNeeded = 8, threshold = 4, anagrams = { "mate", "temp", "team", "teal", "male", "lute", "tape", "meal", "tamp", "tame", "mule", "tale", "alum", "puma", "pule", "plum", "plea", "plat", "leap", "pelt", "peat", "peal", "lamp", "pate", "lept", "palm", "pale", "late", "mute", "maul", "lame", "lump", "melt", "meat", "malt", "tam", "ump", "mat", "map", "mum", "tea", "tau", "tap", "let", "pat", "pet", "lea", "pal", "lap", "pea", "met", "lam", "eta", "emu", "elm", "eat", "ate", "apt", "ape", "amp", "put", "alp", "ale" } },
	{ row = 41, password = "mysafephrase", pointsNeeded = 13, threshold = 9, anagrams = { "pays", "yeps", "farm", "yeas", "year", "yeah", "eyes", "yaps", "espy", "yams", "eras", "hays", "spry", "spay", "spas", "spar", "ears", "hare", "shes", "pyre", "shay", "sham", "serf", "sere", "sera", "sees", "seer", "seep", "seem", "ares", "seas", "sear", "seam", "apes", "says", "amps", "sash", "saps", "maps", "same", "safe", "ryes", "haps", "rhea", "eery", "reps", "ease", "rems", "fray", "refs", "fess", "reef", "reap", "ream", "rays", "ashy", "rasp", "rash", "raps", "fame", "rams", "ramp", "apse", "ahem", "hype", "heap", "prey", "pray", "pram", "perm", "aery", "pees", "peer", "heme", "peas", "pear", "asps", "here", "free", "pass", "army", "pars", "pare", "para", "area", "mess", "mesh", "mesa", "mere", "mays", "ayes", "mass", "mash", "afar", "mars", "mare", "fays", "harm", "arms", "hasp", "easy", "hams", "hers", "ayah", "fear", "harp", "hems", "hemp", "fees", "fare", "hear", "yes", "spy", "map", "she", "has", "hep", "sap", "shy", "rye", "hap", "hes", "ham", "fry", "pay", "rem", "pry", "ref", "fee", "her", "mar", "fay", "fas", "yep", "rah", "far", "rap", "yea", "eye", "yap", "ere", "yam", "era", "ems", "res", "hey", "rep", "spa", "ear", "may", "aye", "fey", "pea", "asp", "ray", "ash", "pas", "hay", "arm", "see", "par", "are", "ram", "sea", "ape", "say", "amp", "hem", "aha", "mas", "per" } },
	{ row = 42, password = "myvombination", pointsNeeded = 11, threshold = 7, anagrams = { "boot", "boon", "boom", "anti", "bony", "tony", "coin", "tomb", "coat", "tiny", "ciao", "maim", "bani", "cant", "taco", "atom", "onto", "omit", "obit", "anon", "iamb", "ammo", "noon", "boat", "coot", "imam", "myna", "icon", "moot", "moon", "bait", "mono", "iota", "city", "moat", "moan", "mint", "mini", "mica", "mayo", "cyan", "cony", "many", "comb", "main", "coma", "into", "mom", "toy", "mac", "inn", "nab", "icy", "tic", "oat", "may", "moo", "cot", "nib", "nay", "coo", "mat", "con", "man", "mot", "ton", "cob", "tom", "mob", "tin", "cay", "cat", "tam", "can", "cam", "cab", "boy", "yon", "yin", "yam", "boo", "too", "nit", "boa", "bit", "bio", "bin", "bay", "bat", "tan", "ban", "coy", "tab", "any", "ion", "ant", "obi", "ani", "not", "aim", "act" } },
	{ row = 43, password = "password", pointsNeeded = 8, threshold = 4, anagrams = { "wrap", "word", "woad", "wasp", "pros", "wars", "warp", "ward", "draw", "wads", "dopa", "swop", "swap", "spas", "spar", "ados", "sows", "pods", "oars", "sops", "drop", "sods", "soda", "pars", "soar", "soap", "saws", "pass", "saps", "asps", "prow", "rows", "pads", "rods", "raps", "road", "raws", "paws", "rasp", "rads", "prod", "saw", "raw", "sad", "was", "rap", "pro", "sow", "pod", "sap", "paw", "rod", "pas", "sod", "par", "row", "pad", "ops", "sos", "oar", "sop", "war", "dos", "wad", "rad", "asp", "ads", "spa", "ado" } },
	{ row = 44, password = "paydaylumps", pointsNeeded = 11, threshold = 7, anagrams = { "yups", "lady", "lads", "yaps", "dump", "yams", "dual", "days", "umps", "dams", "damp", "sump", "maul", "amps", "spud", "spay", "alps", "alas", "slum", "slay", "slap", "slam", "pads", "laps", "maps", "lams", "pups", "pupa", "lump", "pump", "puma", "pulp", "lamp", "plus", "plum", "play", "pays", "lama", "laud", "paps", "papa", "muds", "pals", "palm", "lays", "mays", "alms", "duly", "alum", "mads", "say", "pal", "sum", "pap", "sad", "map", "may", "mad", "pup", "ply", "sly", "pas", "las", "sap", "lap", "pus", "mud", "pay", "lam", "yup", "yum", "lad", "yap", "lay", "yam", "ups", "day", "ump", "sup", "dam", "asp", "spy", "amp", "mas", "spa", "alp", "pad", "mus", "ads" } },
	{ row = 45, password = "podracer", pointsNeeded = 7, threshold = 3, anagrams = { "rope", "carp", "rode", "card", "roar", "road", "cape", "redo", "cope", "care", "rear", "reap", "read", "rare", "aced", "core", "race", "prod", "dear", "pore", "code", "coda", "pear", "aped", "pare", "dare", "acre", "pace", "crap", "oped", "cord", "dace", "crop", "coed", "doer", "capo", "drop", "dope", "dopa", "era", "doe", "doc", "pro", "par", "ode", "rec", "ore", "rad", "ope", "red", "cop", "err", "pod", "per", "cod", "roe", "oar", "rod", "car", "ear", "rep", "cap", "cad", "are", "arc", "pea", "ape", "ado", "pad", "rap", "ace" } },
	{ row = 46, password = "qwertyuiop", pointsNeeded = 11, threshold = 7, anagrams = { "yurt", "pour", "rope", "your", "pore", "yore", "yipe", "pity", "tore", "yeti", "quip", "pyre", "roue", "writ", "prow", "wort", "wore", "prey", "wite", "ripe", "wiry", "wire", "wipe", "quit", "wept", "weir", "tyro", "tyre", "typo", "type", "tour", "pert", "troy", "trow", "trip", "trio", "trey", "poet", "ropy", "euro", "pier", "pout", "port", "rout", "tiro", "tire", "riot", "tier", "rote", "rite", "pure", "two", "rue", "yew", "wry", "tie", "rot", "wot", "yow", "top", "toe", "wit", "rip", "rye", "rep", "wet", "yet", "yep", "put", "roe", "pry", "tip", "pro", "woe", "tor", "yup", "pot", "row", "you", "poi", "toy", "yip", "pit", "rut", "pie", "pew", "pet", "try", "per", "owe", "out", "our", "ore", "opt", "ope", "ire", "tow" } },
	{ row = 47, password = "ragtagsdie", pointsNeeded = 11, threshold = 7, anagrams = { "tsar", "trig", "dirt", "tire", "ties", "tier", "tied", "dies", "tide", "teas", "tear", "data", "tars", "tare", "dais", "tags", "arts", "tads", "arid", "stir", "star", "stag", "site", "airs", "sire", "aids", "side", "etas", "sera", "seat", "sear", "agar", "sate", "gars", "sari", "said", "sage", "saga", "dart", "dare", "rite", "rise", "rigs", "ears", "rids", "ride", "ares", "rest", "gags", "reds", "digs", "read", "rats", "rate", "ages", "raid", "rags", "rage", "raga", "eras", "rads", "drag", "eggs", "ires", "dire", "aria", "ides", "idea", "grit", "grid", "grad", "gist", "girt", "gird", "gigs", "aged", "gets", "egis", "gear", "gate", "egad", "drat", "area", "gait", "date", "gage", "gaga", "aide", "gads", "diet", "east", "dear", "erst", "ergs", "edit", "eats", "era", "gad", "its", "res", "gas", "eds", "erg", "get", "eat", "set", "rig", "ear", "sat", "rad", "dis", "tis", "ire", "red", "dig", "rag", "tie", "die", "eta", "egg", "tea", "sag", "sad", "tar", "ate", "tag", "art", "tad", "ids", "rid", "gar", "are", "sit", "air", "sir", "gag", "aid", "rat", "gig", "age", "sea", "ads" } },
	{ row = 48, password = "rebelsrule", pointsNeeded = 6, threshold = 2, anagrams = { "user", "burl", "sure", "bull", "reel", "slur", "slue", "sere", "sell", "seer", "errs", "ruse", "rule", "rues", "blur", "rubs", "rube", "bees", "beer", "bell", "lure", "lube", "lees", "leer", "burr", "eels", "blue", "burs", "else", "ells", "sub", "see", "eel", "bus", "ell", "lee", "use", "bur", "sue", "brr", "rue", "err", "ere", "rub", "res", "bee" } },
	{ row = 49, password = "scalefish", pointsNeeded = 8, threshold = 4, anagrams = { "each", "sics", "chis", "shes", "chef", "self", "secs", "calf", "seas", "seal", "ilea", "sash", "sale", "sail", "safe", "sacs", "aces", "life", "lies", "lief", "case", "lice", "less", "leis", "flea", "lech", "leas", "leaf", "fess", "lass", "lash", "face", "lacs", "lace", "clef", "isle", "fail", "file", "ices", "ache", "hiss", "cafe", "hies", "fish", "ales", "heal", "ails", "half", "hale", "hail", "cash", "hie", "ifs", "lei", "ice", "fas", "sea", "las", "elf", "sis", "lac", "sic", "chi", "she", "fie", "lie", "sec", "his", "ash", "hes", "ale", "has", "ail", "lea", "sac", "ace" } },
	{ row = 50, password = "secretagent", pointsNeeded = 10, threshold = 6, anagrams = { "tsar", "tree", "test", "tern", "tent", "tens", "cart", "tees", "teen", "etas", "teat", "teas", "tear", "narc", "tats", "eras", "tart", "tars", "tarn", "tare", "arcs", "tans", "tang", "ante", "tags", "ages", "tact", "stet", "stat", "star", "stag", "snag", "cars", "sere", "sera", "sent", "seer", "seen", "eats", "sect", "east", "seat", "sear", "ares", "scat", "scar", "scan", "sate", "gene", "sang", "sane", "sage", "acts", "care", "rest", "acne", "rent", "recs", "earn", "rats", "rate", "arts", "rant", "rang", "cast", "rags", "rage", "ants", "race", "nett", "nets", "cans", "nest", "cent", "neat", "near", "aces", "nags", "ears", "erst", "gnat", "gets", "cant", "gent", "ease", "gees", "cage", "gear", "gate", "acre", "gars", "cats", "case", "cane", "crag", "ergs", "erg", "nae", "tee", "tea", "ens", "see", "eat", "sec", "sat", "nag", "rec", "ear", "ere", "nee", "era", "cat", "ran", "tat", "ten", "set", "sac", "car", "get", "net", "eta", "can", "gee", "ate", "rat", "art", "sea", "are", "tar", "arc", "rag", "tan", "ant", "tag", "age", "sag", "act", "gas", "res", "gar", "ace" } },
	{ row = 51, password = "selonian", pointsNeeded = 9, threshold = 5, anagrams = { "inns", "soli", "sole", "eons", "soil", "sloe", "sine", "anon", "silo", "seal", "aloe", "sane", "sale", "sail", "ones", "aeon", "oles", "lane", "oils", "elan", "nose", "lean", "none", "noes", "noel", "nine", "nils", "ions", "neon", "nail", "ales", "lose", "lone", "loin", "loan", "lion", "line", "lies", "lien", "also", "lens", "leis", "ilea", "leas", "isle", "lain", "ails", "nae", "lea", "nos", "nil", "ion", "ins", "las", "inn", "lei", "sol", "eon", "ens", "oil", "sin", "ani", "lie", "sea", "ole", "ale", "son", "ail", "one" } },
	{ row = 52, password = "slicehound", pointsNeeded = 13, threshold = 9, anagrams = { "used", "done", "undo", "dole", "sued", "hind", "such", "soul", "docs", "hide", "soli", "sole", "sold", "dins", "soil", "eons", "slue", "sloe", "slid", "sled", "sine", "deli", "silo", "side", "duns", "shun", "shoe", "shod", "shin", "shed", "ides", "send", "coin", "scud", "ouch", "onus", "ones", "dohs", "once", "oles", "chis", "olds", "chid", "oils", "disc", "hoes", "odes", "dine", "duos", "nude", "nosh", "nose", "dens", "noes", "noel", "nods", "node", "dose", "nils", "dons", "nice", "lush", "loud", "lose", "lone", "loin", "lode", "loci", "loch", "lion", "line", "lieu", "lies", "lien", "lied", "dies", "lids", "lido", "coil", "lice", "lens", "lend", "leis", "clue", "cuds", "lech", "isle", "ions", "cone", "dish", "inch", "ends", "idol", "idle", "echo", "icon", "ices", "iced", "clod", "hues", "hued", "cues", "hose", "held", "hons", "hone", "cons", "hole", "hold", "cold", "hoed", "duel", "hods", "coed", "cods", "code", "hies", "hied", "dice", "dune", "chin", "does", "hens", "cued", "dues", "ohs", "hie", "lid", "ids", "hen", "eds", "she", "lei", "hos", "hon", "son", "dun", "duh", "eon", "hoe", "due", "nod", "dos", "nil", "use", "don", "sun", "one", "doh", "hes", "doe", "sou", "doc", "ins", "oil", "dis", "sol", "ode", "din", "lie", "die", "duo", "nos", "den", "sin", "hue", "end", "cue", "led", "cud", "cos", "sic", "ion", "con", "sod", "sec", "ens", "hod", "his", "sue", "cod", "nus", "ice", "ole", "hid", "old", "chi" } },
	{ row = 53, password = "sneaky", pointsNeeded = 6, threshold = 2, anagrams = { "sank", "yens", "easy", "yeas", "kens", "yank", "yaks", "sane", "ayes", "keys", "sake", "nays", "yes", "yak", "sea", "say", "nay", "nae", "ska", "key", "yea", "ken", "ens", "yen", "sky", "aye", "ask", "any" } },
	{ row = 54, password = "tabage", pointsNeeded = 5, threshold = 1, anagrams = { "beta", "beat", "bate", "gate", "abet", "tea", "gab", "eat", "get", "bet", "beg", "eta", "tab", "bat", "bag", "baa", "ate", "age", "tag" } },
	{ row = 55, password = "tezirettseed", pointsNeeded = 8, threshold = 4, anagrams = { "zits", "ides", "zest", "zeds", "seed", "tree", "rise", "dirt", "tire", "ties", "tier", "tied", "deer", "tide", "test", "tees", "teed", "seer", "stir", "stet", "size", "site", "ires", "sire", "ditz", "side", "erst", "sere", "rest", "edit", "reed", "rite", "diet", "rids", "ride", "dies", "dire", "reds", "see", "res", "red", "its", "tee", "ids", "zit", "set", "ere", "eds", "zed", "sir", "dis", "tis", "sit", "ire", "rid", "die", "tie" } },
	{ row = 56, password = "thedecider", pointsNeeded = 7, threshold = 3, anagrams = { "tree", "tire", "tier", "tied", "dice", "tide", "deed", "thee", "chit", "teed", "diet", "tech", "rite", "ride", "edit", "rich", "rice", "reed", "died", "chid", "itch", "cede", "iced", "heir", "cite", "hire", "hied", "heed", "hide", "dire", "here", "herd", "deer", "dirt", "etch", "hie", "ere", "rid", "ice", "hid", "tee", "red", "die", "did", "tie", "her", "tic", "hit", "the", "rec", "chi", "ire" } },
	{ row = 57, password = "theedpalace", pointsNeeded = 11, threshold = 7, anagrams = { "thee", "dace", "teed", "clad", "tech", "teal", "cede", "tape", "cape", "tale", "talc", "heap", "pled", "plea", "plat", "phat", "data", "pelt", "peel", "aced", "peat", "peal", "head", "path", "pate", "deep", "pale", "date", "aped", "pact", "pace", "clap", "lept", "chat", "chap", "lech", "leap", "lead", "heat", "lath", "late", "hale", "lade", "etch", "lace", "epee", "each", "help", "held", "heel", "heed", "dale", "hate", "heal", "ache", "deal", "halt", "pad", "hap", "lap", "had", "hep", "eta", "lac", "eel", "eat", "hat", "pat", "lea", "pal", "pet", "lad", "pea", "let", "tee", "lee", "led", "tea", "cat", "tap", "cap", "cad", "ate", "apt", "tad", "ape", "alp", "ale", "aha", "act", "the", "ace" } },
	{ row = 58, password = "theking", pointsNeeded = 6, threshold = 2, anagrams = { "ting", "tine", "hike", "tike", "king", "thin", "then", "gent", "kith", "kine", "nite", "kent", "nigh", "kite", "knit", "hint", "net", "ten", "tie", "kit", "kin", "nit", "ken", "keg", "ink", "hit", "nth", "tin", "hie", "hen", "gin", "get", "th" } },
	{ row = 59, password = "thekingsjester", pointsNeeded = 13, threshold = 9, anagrams = { "trig", "trek", "tree", "hike", "hies", "tire", "tint", "tins", "ting", "tine", "hens", "tike", "ties", "tier", "grin", "this", "thin", "then", "thee", "gets", "test", "tern", "tent", "tens", "geek", "tees", "teen", "ergs", "stir", "stet", "snit", "skit", "skis", "skin", "jest", "sits", "site", "kiss", "irks", "sirs", "sire", "grit", "sins", "sink", "sing", "sine", "keen", "sign", "sigh", "shin", "shes", "jerk", "sets", "erst", "sere", "sent", "sees", "seer", "seen", "seek", "egis", "rite", "risk", "rise", "rink", "ring", "rigs", "hint", "rest", "gent", "rent", "rein", "reek", "here", "nits", "nite", "hist", "nigh", "nett", "nets", "gist", "nest", "gins", "knit", "knee", "kits", "kith", "kite", "gees", "hire", "king", "kine", "ires", "kent", "kens", "hers", "kegs", "hits", "jeer", "jigs", "gene", "jets", "inks", "ekes", "girt", "hiss", "heir", "its", "irk", "kin", "sin", "ins", "jet", "ink", "keg", "hit", "nit", "ire", "his", "sit", "rig", "tis", "hie", "hes", "ken", "ski", "her", "tin", "hen", "sis", "sir", "tie", "net", "she", "nee", "gin", "the", "get", "res", "jig", "kit", "ten", "gee", "set", "tee", "erg", "ere", "ens", "nth", "eke", "see", "eek" } },
	{ row = 60, password = "tyrena", pointsNeeded = 7, threshold = 3, anagrams = { "earn", "near", "year", "nary", "yarn", "tyre", "neat", "trey", "tray", "tern", "aery", "tear", "arty", "tarn", "tare", "rant", "ante", "rate", "rent", "ray", "rye", "rat", "tar", "ran", "net", "try", "yen", "nay", "yea", "nae", "eta", "era", "eat", "yet", "ear", "aye", "ate", "tea", "art", "are", "any", "tan", "ant", "ten" } },
	{ row = 61, password = "tyrenapretty", pointsNeeded = 11, threshold = 7, anagrams = { "nape", "reap", "pate", "year", "part", "yarn", "rapt", "tyre", "type", "eery", "trey", "tree", "tray", "trap", "tern", "tent", "pert", "teen", "pent", "teat", "tear", "ante", "pane", "tart", "tarp", "tarn", "tare", "neat", "tape", "earn", "pare", "nary", "pant", "rent", "rear", "peen", "prey", "rate", "pear", "rare", "arty", "peat", "rant", "neap", "pyre", "eyry", "near", "pray", "nett", "peer", "aery", "per", "ray", "ten", "yep", "rap", "rat", "ran", "tee", "yen", "pat", "yea", "tan", "par", "yap", "tat", "pan", "pet", "net", "nee", "tar", "pen", "pea", "nay", "rye", "yet", "nap", "nae", "pay", "eye", "eta", "err", "ere", "era", "try", "eat", "tap", "ear", "aye", "ate", "rep", "art", "are", "apt", "ape", "any", "tea", "ant", "pry" } },
}

MtpMinigameData.SKIPPED_COLUMNS = 2 -- slicing_minigame.java:42
MtpMinigameData.DEFAULT_ANAGRAM_POINT = 1 -- slicing_minigame.java:43
MtpMinigameData.BUFF_THRESHOLD_INCREASE = 3 -- slicing_minigame.java:44
MtpMinigameData.BUFF_POINTS_NEEDED_DECREASE = 1 -- slicing_minigame.java:45

-- meatlump_target_map_text.tab
MtpMinigameData.mapText = {
	{ row = 3, prefix = "This city won't know what hit 'em. Change out of your Meatlump Uniform and enter the city from the North side. Move directly to your target.", target = "Speeder Garage", trail = "East Coronet", planet = "Corellia" },
	{ row = 4, prefix = "We need to show everyone in this city that technology is bad m'kay? Go directly to this city and carry out your mission.", target = "Cloning Facility", trail = "West Coronet", planet = "Corellia" },
	{ row = 5, prefix = "Take your team and scout out the following target well in advance. No mess ups.", target = "Shuttle Port A", trail = "East Coronet", planet = "Corellia" },
	{ row = 6, prefix = "The King wanted this target taken out by the best but we had to settle for you because our best blew off his hands in the last mission. ", target = "Shuttle Port B", trail = "South Coronet", planet = "Corellia" },
	{ row = 7, prefix = "We are spelling this out for you in simple steps because we know you are not the sharpest individual.", target = "City Spaceport", trail = "South Coronet", planet = "Corellia" },
	{ row = 8, prefix = "Approach the city from the West and await the signal.  When you receive the signal (your superiour slapping the back of your head) proceed to the target and place explosives.", target = "Banking Terminals", trail = "South Coronet", planet = "Corellia" },
	{ row = 9, prefix = "You messed up the last target so here is another chance to show you are worthy of your current rank.", target = "Bazaar Terminals", trail = "South Coronet", planet = "Corellia" },
	{ row = 10, prefix = "Make sure the explosion can be heard by the newspaper people.  We want to show them we ain't so dumb like they say.", target = "Capital Building Generators", trail = "Central Coronet", planet = "Corellia" },
	{ row = 11, prefix = "The King has chosen you to take on a super secret demolitions mission.  He told me he doesn't think you are smart enough to pull this off and that you smell funny...but I think differently.", target = "Cantina Rebel Terminals", trail = "West Coronet", planet = "Corellia" },
	{ row = 12, prefix = "The recently promoted Decider has decided to take volunteers for the next mission. Since no one volunteered he picked you. Ha ha.", target = "Crafting Stations", trail = "South Coronet", planet = "Corellia" },
	{ row = 13, prefix = "Hope you don't mind traveling because your target involves a bit of travel.  Proceed with caution as we have hit this city before.  Make sure you aren't followed.", target = "Medical Center", trail = "South Bestine", planet = "Tatooine" },
	{ row = 14, prefix = "This city won't know what hit 'em. Change out of your Meatlump Uniform and enter the city from the North side. Move directly to your target.", target = "Vaporators", trail = "Mos Eisley", planet = "Tatooine" },
	{ row = 15, prefix = "We need to show everyone in this city that technology is bad m'kay? Go directly to this city and carry out your mission.", target = "Theed Palace", trail = "Northern Theed", planet = "Naboo" },
	{ row = 16, prefix = "Take your team and scout out the following target well in advance. No mess ups.", target = "Spaceport Terminals", trail = "Mos Espa", planet = "Tatooine" },
	{ row = 17, prefix = "The King wanted this target taken out by the best but we had to settle for you because our best blew off his hands in the last mission. ", target = "Hotel Lobby", trail = "Tyrena", planet = "Corellia" },
	{ row = 18, prefix = "We are spelling this out for you in simple steps because we know you are not the sharpest individual.", target = "Hotel Lobby", trail = "Bestine", planet = "Tatooine" },
	{ row = 19, prefix = "Approach the city from the West and await the signal.  When you receive the signal (your superiour slapping the back of your head) proceed to the target and place explosives.", target = "Cantina Top Floor", trail = "Achorhead", planet = "Tatooine" },
	{ row = 20, prefix = "You messed up the last target so here is another chance to show you are worthy of your current rank.", target = "Shuttle Port", trail = "Achorhead", planet = "Tatooine" },
	{ row = 21, prefix = "Make sure the explosion can be heard by the newspaper people.  We want to show them we ain't so dumb like they say.", target = "Shuttle Port", trail = "Wayfar", planet = "Tatooine" },
	{ row = 22, prefix = "The King has chosen you to take on a super secret demolitions mission.  He told me he doesn't think you are smart enough to pull this off and that you smell funny...but I think differently.", target = "Cantina Lounge", trail = "Wayfar", planet = "Tatooine" },
	{ row = 23, prefix = "The recently promoted Decider has decided to take volunteers for the next mission. Since no one volunteered he picked you. Ha ha.", target = "Shuttle Port B", trail = "Mos Eisley", planet = "Tatooine" },
	{ row = 24, prefix = "Hope you don't mind traveling because your target involves a bit of travel.  Proceed with caution as we have hit this city before.  Make sure you aren't followed.", target = "Shuttle Port A", trail = "Mos Eisley", planet = "Tatooine" },
	{ row = 25, prefix = "This city won't know what hit 'em. Change out of your Meatlump Uniform and enter the city from the North side. Move directly to your target.", target = "Cantina Bottom Floor", trail = "Mos Eisley", planet = "Tatooine" },
	{ row = 26, prefix = "We need to show everyone in this city that technology is bad m'kay? Go directly to this city and carry out your mission.", target = "City Spaceport", trail = "Mos Espa", planet = "Tatooine" },
	{ row = 27, prefix = "Take your team and scout out the following target well in advance. No mess ups.", target = "Crafting Stations", trail = "Mos Espa", planet = "Tatooine" },
	{ row = 28, prefix = "The King wanted this target taken out by the best but we had to settle for you because our best blew off his hands in the last mission. ", target = "Banking Terminals", trail = "Mos Espa", planet = "Tatooine" },
	{ row = 29, prefix = "We are spelling this out for you in simple steps because we know you are not the sharpest individual.", target = "Medical Center", trail = "Theed", planet = "Naboo" },
	{ row = 30, prefix = "Approach the city from the West and await the signal.  When you receive the signal (your superiour slapping the back of your head) proceed to the target and place explosives.", target = "Hotel Lobby", trail = "Theed", planet = "Naboo" },
	{ row = 31, prefix = "You messed up the last target so here is another chance to show you are worthy of your current rank.", target = "Shuttle Port A", trail = "Theed", planet = "Naboo" },
	{ row = 32, prefix = "Make sure the explosion can be heard by the newspaper people.  We want to show them we ain't so dumb like they say.", target = "Shuttle Port B", trail = "Theed", planet = "Naboo" },
	{ row = 33, prefix = "The King has chosen you to take on a super secret demolitions mission.  He told me he doesn't think you are smart enough to pull this off and that you smell funny...but I think differently.", target = "City Spaceport", trail = "Theed", planet = "Naboo" },
	{ row = 34, prefix = "The recently promoted Decider has decided to take volunteers for the next mission. Since no one volunteered he picked you. Ha ha.", target = "Shuttle Port", trail = "Nashal", planet = "Talus" },
	{ row = 35, prefix = "Hope you don't mind traveling because your target involves a bit of travel.  Proceed with caution as we have hit this city before.  Make sure you aren't followed.", target = "Hotel Lobby", trail = "Nashal", planet = "Talus" },
	{ row = 36, prefix = "This city won't know what hit 'em. Change out of your Meatlump Uniform and enter the city from the North side. Move directly to your target.", target = "City Spaceport", trail = "Nashal", planet = "Talus" },
	{ row = 37, prefix = "We need to show everyone in this city that technology is bad m'kay? Go directly to this city and carry out your mission.", target = "Banking Terminals", trail = "Nashal", planet = "Talus" },
	{ row = 38, prefix = "Take your team and scout out the following target well in advance. No mess ups.", target = "Bazaar Terminals", trail = "Nashal", planet = "Talus" },
	{ row = 39, prefix = "The King wanted this target taken out by the best but we had to settle for you because our best blew off his hands in the last mission. ", target = "Speeder Garage", trail = "Nashal", planet = "Talus" },
	{ row = 40, prefix = "We are spelling this out for you in simple steps because we know you are not the sharpest individual.", target = "Cloning Facility", trail = "Nashal", planet = "Talus" },
	{ row = 41, prefix = "Approach the city from the West and await the signal.  When you receive the signal (your superiour slapping the back of your head) proceed to the target and place explosives.", target = "Starport Terminals", trail = "Pirate Outpost", planet = "Dantooine" },
	{ row = 42, prefix = "You messed up the last target so here is another chance to show you are worthy of your current rank.", target = "Starport Terminals", trail = "Mining Outpost", planet = "Dantooine" },
	{ row = 43, prefix = "Make sure the explosion can be heard by the newspaper people.  We want to show them we ain't so dumb like they say.", target = "Crafting Stations", trail = "Pirate Outpost", planet = "Dantooine" },
	{ row = 44, prefix = "The King has chosen you to take on a super secret demolitions mission.  He told me he doesn't think you are smart enough to pull this off and that you smell funny...but I think differently.", target = "Medical Center", trail = "Pirate Outpost", planet = "Dantooine" },
	{ row = 45, prefix = "The recently promoted Decider has decided to take volunteers for the next mission. Since no one volunteered he picked you. Ha ha.", target = "Bazaar Terminals", trail = "Mining Outpost", planet = "Dantooine" },
	{ row = 46, prefix = "Hope you don't mind traveling because your target involves a bit of travel.  Proceed with caution as we have hit this city before.  Make sure you aren't followed.", target = "Hotel Lobby", trail = "Pirate Outpost", planet = "Dantooine" },
	{ row = 47, prefix = "Approach the city from the West and await the signal.  When you receive the signal (your superiour slapping the back of your head) proceed to the target and place explosives.", target = "Crafting Stations", trail = "Mining Outpost", planet = "Dantooine" },
	{ row = 48, prefix = "You messed up the last target so here is another chance to show you are worthy of your current rank.", target = "Cantina Lounge", trail = "Pirate Outpost", planet = "Dantooine" },
	{ row = 49, prefix = "Make sure the explosion can be heard by the newspaper people.  We want to show them we ain't so dumb like they say.", target = "Medical Center", trail = "Pirate Outpost", planet = "Dantooine" },
	{ row = 50, prefix = "The King has chosen you to take on a super secret demolitions mission.  He told me he doesn't think you are smart enough to pull this off and that you smell funny...but I think differently.", target = "Cloning Facility", trail = "Mining Outpost", planet = "Dantooine" },
	{ row = 51, prefix = "The recently promoted Decider has decided to take volunteers for the next mission. Since no one volunteered he picked you. Ha ha.", target = "City Spaceport", trail = "Pirate Outpost", planet = "Dantooine" },
	{ row = 52, prefix = "Hope you don't mind traveling because your target involves a bit of travel.  Proceed with caution as we have hit this city before.  Make sure you aren't followed.", target = "Bazaar Terminals", trail = "Mining Outpost", planet = "Dantooine" },
}

-- target_map_puzzle.java CIPHER_ARRAY_1 / 2 / 3 (plaintext a-zA-Z = 52 glyphs)
MtpMinigameData.CIPHER_PLAIN = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
MtpMinigameData.CIPHER_1 = "!@#$3^&*()_+-=[]/|?/><`~;2!@#$3^&*()_+-=[]/|?/><`~;2" -- java:100-151
MtpMinigameData.CIPHER_2 = "¤þ#ðêf&*îj_¶-nØ¿/®s^ü<`~¥z¤þ#ðêf&*îj_¶-nØ¿/®s^ü<`~¥z" -- java:213-264
MtpMinigameData.CIPHER_3 = "48©d3f6#1j_|mn0Þð®5+ü<w~/248©d3f6#1j_|mn0Þð®5+ü<w~/2" -- java:326-377

-- disarm_bomb_puzzle.java:55-93
MtpMinigameData.DEFAULT_BOMB_TIMER = 65
MtpMinigameData.BUFF_TIMER_INCREASE = 10
MtpMinigameData.BUTTON_PENALTY = 5
MtpMinigameData.DEFUSE_TIME_OUT_SECONDS = 120
MtpMinigameData.WIRE_LIST = {
	"Power Source \\#FF3300+\\#FFFFFF ",
	"Power Source \\#222222-\\#FFFFFF ",
	"Explosive \\#FF3300+\\#FFFFFF ",
	"Explosive \\#222222-\\#FFFFFF ",
	"Detonator \\#FF3300+\\#FFFFFF ",
	"Detonator \\#222222-\\#FFFFFF ",
	"Initiation System \\#FF3300+\\#FFFFFF ",
	"Initiation System \\#222222-\\#FFFFFF ",
	"Tamper System \\#FF3300+\\#FFFFFF ",
	"Tamper System \\#222222-\\#FFFFFF ",
}
MtpMinigameData.COLOR_LIST = {
	"\\#FF3300Red\\#FFFFFF",
	"\\#222222Black\\#FFFFFF",
	"\\#996600Brown\\#FFFFFF",
	"\\#FFFF00Yellow\\#FFFFFF",
	"White",
	"\\#99FF33Green\\#FFFFFF",
	"\\#FF3300Red \\#222222Black\\#FFFFFF",
	"\\#FFFF00Yellow \\#99FF33Green\\#FFFFFF",
	"\\#FFFF00Yellow \\#996600Brown\\#FFFFFF",
	"\\#222222Black \\#FFFFFFWhite",
}
MtpMinigameData.CUT_LIST = { "cut_red", "cut_black", "cut_brown", "cut_yellow", "cut_white", "cut_green", "cut_red_black", "cut_yellow_green", "cut_yellow_brown", "cut_black_white" }

function MtpMinigameData.thresholdsFor(combinations)
	return MtpMinigameData.thresholds[combinations]
end

-- code_break_minigame.java:188-241 handleDialogInput
function MtpMinigameData.evaluateCodeBreakGuess(secret, guess)
	local n = tonumber(guess)

	if (n == nil or n < 0) then
		return "invalid"
	end

	if (n == secret) then
		return "correct"
	elseif (n > secret) then
		return "too_high"
	else
		return "too_low"
	end
end

-- code_break_minigame.java:381-405 calculateThreshold; :429-442 all thresholds
function MtpMinigameData.evaluateCodeBreakThresholds(guessCounts, combinationCount)
	local thresh = MtpMinigameData.thresholdsFor(combinationCount)

	if (thresh == nil) then
		return false
	end

	local allMet = true

	for i = 1, combinationCount do
		local count = guessCounts[i] or 0
		local limit = thresh[i] or 0

		if (count >= limit) then
			allMet = false
		end
	end

	return allMet
end

-- slicing_minigame.java:167-276 handleDialogInput
function MtpMinigameData.evaluateSlicingGuess(row, guess, guessList, pointsCurrent, wrongCount)
	if (row == nil or guess == nil) then
		return "wrong"
	end

	if (guess == row.password) then
		return "win"
	end

	if (guessList ~= nil) then
		for i = 1, #guessList do
			if (guessList[i] == guess) then
				return "already"
			end
		end
	end

	if (string.len(guess) > 4) then
		return "too_long"
	end

	local hit = false

	for i = 1, #row.anagrams do
		if (row.anagrams[i] == guess) then
			hit = true
			break
		end
	end

	if (hit) then
		local nextPoints = (pointsCurrent or 0) + MtpMinigameData.DEFAULT_ANAGRAM_POINT

		if (nextPoints >= row.pointsNeeded) then
			return "win"
		end

		return "anagram"
	end

	if ((wrongCount or 0) >= row.threshold) then
		return "fail"
	end

	return "wrong"
end

-- target_map_puzzle.java:531-556
function MtpMinigameData.evaluateMapGuess(correctPhrase, guess)
	if (correctPhrase == nil or guess == nil) then
		return "fail"
	end

	if (string.lower(guess) == string.lower(correctPhrase)) then
		return "win"
	end

	return "fail"
end

function MtpMinigameData.applyCipher(text, cipher)
	local plain = MtpMinigameData.CIPHER_PLAIN
	local glyphs = {}

	for _, code in utf8.codes(cipher) do
		glyphs[#glyphs + 1] = utf8.char(code)
	end

	local out = {}

	for i = 1, string.len(text) do
		local ch = string.sub(text, i, i)
		local pos = string.find(plain, ch, 1, true)

		if (pos == nil or glyphs[pos] == nil) then
			out[#out + 1] = ch
		else
			out[#out + 1] = glyphs[pos]
		end
	end

	return table.concat(out)
end

-- The cipher glyph for one plaintext character (the same mapping applyCipher
-- uses; ciphers 2 and 3 hold multi-byte glyphs, so callers must never index
-- a ciphered string by byte).
function MtpMinigameData.cipherGlyph(ch, cipher)
	local pos = string.find(MtpMinigameData.CIPHER_PLAIN, ch, 1, true)

	if (pos == nil) then
		return ch
	end

	local i = 0

	for _, code in utf8.codes(cipher) do
		i = i + 1

		if (i == pos) then
			return utf8.char(code)
		end
	end

	return ch
end

-- disarm_bomb_puzzle.java:370-506: sequential cuts, wrong cut explodes
function MtpMinigameData.evaluateBombCut(cutArray, buttonNumber, wire)
	if (cutArray == nil or wire == nil or wire == "") then
		return "cancel"
	end

	local expected = cutArray[buttonNumber]

	if (expected ~= wire) then
		return "explode"
	end

	if (buttonNumber >= #cutArray) then
		return "win"
	end

	return "correct"
end

