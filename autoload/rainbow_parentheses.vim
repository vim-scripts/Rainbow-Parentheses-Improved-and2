"==========================================================
"Simple Configuration
"first, put the rainbow_parentheses.vim to dir vim73/autoload
"second, add the follow sentence to your .vimrc or _vimrc :
"		au syntax * cal rainbow_parentheses#activate()
"third, restart your vim and enjoy coding.

let s:colorpairs = [
			\ ['darkgray',    'DarkOrchid3'],
			\ ['brown',       'RoyalBlue3'],
			\ ['Darkblue',    'SeaGreen3'],
			\ ['darkgreen',   'firebrick3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['darkcyan',    'RoyalBlue3'],
			\ ['darkred',     'SeaGreen3'],
			\ ['brown',       'firebrick3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['gray',        'RoyalBlue3'],
			\ ['black',       'SeaGreen3'],
			\ ['Darkblue',    'firebrick3'],
			\ ['darkred',     'DarkOrchid3'],
			\ ['darkgreen',   'RoyalBlue3'],
			\ ['darkcyan',    'SeaGreen3'],
			\ ['red',         'firebrick3'],
			\ ]

func! s:extend()
	if s:max > len(s:colorpairs)
		cal extend(s:colorpairs, s:colorpairs)
		cal s:extend()
	elseif s:max < len(s:colorpairs)
		cal remove(s:colorpairs, s:max, -1)
	endif
endfunc

func! s:cluster()
	let levels = ''
	for each in range(1, s:max)
		let levels .= ',level'.each
	endfor
	exe 'syn cluster rainbow_parentheses contains=@TOP'.levels.',NoInParens'
endfunc

func! rainbow_parentheses#load(type, max)
	let s:types = [['(',')'],['\[','\]'],['{','}'],['<','>']]
	if (a:max == 0)
		let s:max = len(s:colorpairs)
	else 
		let s:max = a:max
	endif
	cal s:extend()
	cal s:cluster()
	for which in range(0, 3)
		let flag = (match(a:type, s:types[which][0]) != -1)
		if flag
			let [level, grp, alllvls, type] = ['', '', [], s:types[which]]
			for each in range(1, s:max)
				cal add(alllvls, 'level'.each)
			endfor
			for each in range(1, s:max)
				let region = 'level'.each
				let grp = 'level'.each.'c'
				let cmd = 'syn region %s matchgroup=%s start=/%s/ end=/%s/ contains=TOP,%s,NoInParens'
				exe printf(cmd, region, grp, type[0], type[1], join(alllvls, ','))
				cal remove(alllvls, 0)
			endfor
		endif
	endfor
	let s:loaded = 1
	cal rainbow_parentheses#activate()
endfunc

func! rainbow_parentheses#activate()
	if !exists('s:active') || s:active == 0
		if !exists('s:loaded')
			cal rainbow_parentheses#load('([{' , 32)
		endif
		let id = 1
		for [ctermfg, guifg] in s:colorpairs
			exe 'hi default level'.id.'c ctermfg='.ctermfg.' guifg='.guifg
			let id += 1
		endfor
		let s:active = 1
	endif
endfunc

func! rainbow_parentheses#clear()
	if exists('s:active') && s:active == 1
		for each in range(1, s:max)
			exe 'hi clear level'.each.'c'
		endfor
		let s:active = 0
	endif
endfunc

func! rainbow_parentheses#toggle()
	if exists('s:active') && s:active == 1
		cal rainbow_parentheses#clear()
	else
		cal rainbow_parentheses#activate()
	endif
endfunc

" vim:ts=2:sw=2:sts=2
