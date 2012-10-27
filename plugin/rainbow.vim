"==============================================================================
"Script Title: rainbow parentheses improved
"Script Version: 2.41
"Author: luochen1990
"Last Edited: 2012 Oct 28
"Simple Configuration:
"	first, put "rainbow.vim"(this file) to dir vim73/plugin or vimfiles/plugin
"	second, add the follow sentence to your .vimrc or _vimrc :
"
"	 		let g:rainbow_active = 1
"
"	third, restart your vim and enjoy coding.
"Advanced Configuration:
"	an advanced configuration allows you to define what parentheses to use 
"	for each type of file . you can also determine the colors of your 
"	parentheses by this way.
"		e.g. this is an advanced config (add these sentences to your vimrc):
"
"	 		let g:rainbow_active = 1
"  	 
"  	 		let g:rainbow_load_separately = [
"			\	[ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"			\	[ '*.tex' , [['(', ')'], ['\[', '\]']] ],
"			\	[ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"			\	[ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
"			\	]
"  	 
"  	 		let g:rainbow_guifgs = ['RoyalBlue3', 'SeaGreen3', 'DarkOrange3', 'FireBrick',]
"
"User Command:
"	:RainbowToggle		--you can use it to toggle this plugin.


let s:guifgs = exists('g:rainbow_guifgs')? g:rainbow_guifgs : [
			\ 'DarkOrchid3', 'RoyalBlue3', 'SeaGreen3',
			\ 'DarkOrange3', 'FireBrick', 
			\ ]

let s:ctermfgs = exists('g:rainbow_ctermfgs')? g:rainbow_ctermfgs : [
			\ 'darkgray', 'Darkblue', 'darkmagenta', 
			\ 'darkcyan', 'darkred', 'darkgreen',
			\ ]

let s:max = has('gui_running')? len(s:guifgs) : len(s:ctermfgs)

func rainbow#load(...)
	if exists('b:loaded')
		cal rainbow#clear()
	endif
	let b:loaded = (a:0 < 1) ? [['(',')'],['\[','\]'],['{','}']] : a:1
	let cmd = 'syn region %s matchgroup=%s start=+%s+ end=+%s+ containedin=%s contains=%s'
	let str = 'TOP'
	for each in range(1, s:max)
		let str .= ',lv'.each
	endfor
	for [left , right] in b:loaded
		for each in range(1, s:max - 1)
			exe printf(cmd, 'lv'.each, 'lv'.each.'c', left, right, 'lv'.(each+1) , str)
		endfor
		exe printf(cmd, 'lv'.s:max, 'lv'.s:max.'c', left, right, 'lv1' , str)
	endfor
	if (match(a:000 , 'later') == -1)
		cal rainbow#activate()
	endif
endfunc

func rainbow#clear()
	unlet b:loaded
	for each in range(1 , s:max)
		exe 'syn clear lv'.each
	endfor
endfunc

func rainbow#activate()
	if !exists('b:loaded')
		cal rainbow#load()
	endif
	for id in range(1 , s:max)
		let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
		let guifg = s:guifgs[(s:max - id) % len(s:guifgs)]
		exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
	endfor
	let b:active = 'active'
endfunc

func rainbow#inactivate()
	if exists('b:active')
		for each in range(1, s:max)
			exe 'hi clear lv'.each.'c'
		endfor
		unlet b:active
	endif
endfunc

func rainbow#toggle()
	if exists('b:active')
		cal rainbow#inactivate()
	else
		cal rainbow#activate()
	endif
endfunc

if exists('g:rainbow_active') && g:rainbow_active
	if exists('g:rainbow_load_separately')
		let ps = g:rainbow_load_separately
		for i in range(len(ps))
			exe printf('auto bufreadpost %s call rainbow#load(ps[%d][1])' , ps[i][0] , i)
		endfor
	else
		auto bufnewfile,bufreadpost * call rainbow#activate()
	endif 
endif

command! RainbowToggle call rainbow#toggle()

