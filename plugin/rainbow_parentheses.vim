"==========================================================
"Version: 2.0
"Author: luochen1990
"Last Edited: 2012 Aug 22
"Vim Version: 7.3.46
"Simple Configuration:
"first, put the rainbow_parentheses.vim to dir vim73/plugin
"second, add the follow sentence to your .vimrc or _vimrc :
"		au syntax * cal rainbow_parentheses#activate()
"third, restart your vim and enjoy coding.
"Advanced Configuration:
"use rainbow_parentheses#load(...) to load your setting:
"		a:1 means the kinds of parentheses to match
"		a:2 means the deepth of parentheses
"			e.g. au syntax * cal rainbow_parentheses#load(
"					\	[['(',')'],['\[','\]'],['{','}'],['begin','end']]
"					\	, 64 , 'instantly')
"you can also change the colors by editting the value of
"	s:guifgs or s:ctermfgs.
"use command rptoggle to toggle this plugin.


let s:guifgs = [ 
			\ 'DarkOrchid3', 'RoyalBlue3', 'SeaGreen3', 'green', 
			\ 'yellow', 'orange', 'firebrick3', 
			\ ]

let s:ctermfgs = [
      \ 'darkgray', 'brown', 'Darkblue', 'darkgreen',
      \ 'darkmagenta', 'darkcyan', 'darkred', 'brown',
      \ 'darkmagenta', 'gray', 'black', 'Darkblue',
      \ 'darkred', 'darkgreen', 'darkcyan', 'red',
      \	]

func! rainbow_parentheses#load(...)
	let s:loaded = (a:0 < 1) ? [['(',')'],['\[','\]'],['{','}']] : a:1
	let s:max = (a:0 < 2) ? 32 : a:2
	let cmd = 'syn region %s matchgroup=%s start=/%s/ end=/%s/ containedin=%s'
	for [left , right] in s:loaded
		for each in range(1, s:max)
			exe printf(cmd, 'lv'.each, 'lv'.each.'c', left, right, 'lv'.(each+1))
		endfor
	endfor
	if (a:0 >= 3 && a:3 == 'instantly')
		cal rainbow_parentheses#activate()
	endif
endfunc

func! rainbow_parentheses#activate()
	if !exists('s:active')
		if !exists('s:loaded')
			cal rainbow_parentheses#load()
		endif
		for id in range(1 , s:max)
			let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
			let guifg = s:guifgs[(s:max - id) % len(s:guifgs)]
			exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
		endfor
		let s:active = 'on'
	endif
endfunc

func! rainbow_parentheses#clear()
	if exists('s:active') && s:active == 1
		for each in range(1, s:max)
			exe 'hi clear lv'.each.'c'
		endfor
		unlet s:active
	endif
endfunc

func! rainbow_parentheses#toggle()
	if exists('s:active') && s:active == 1
		cal rainbow_parentheses#clear()
	else
		cal rainbow_parentheses#activate()
	endif
endfunc

command! -nargs=0 RPToggle call rainbow_parentheses#toggle()
" vim:ts=2:sw=2:sts=2
