:syntax on

" YCM
"filetype off
"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
"Plugin 'Shougo/neocomplete'
"Plugin 'Shougo/neosnippet'
"Plugin 'Shougo/neosnippet-snippets'
Plugin 'ycm-core/YouCompleteMe'
call vundle#end()

":autocmd FileType * set formatoptions=tcql
"\ nocindent comments&
":autocmd FileType c,cpp set formatoptions=croql
"\ cindent comments=sr:/*,mb:*,ex:*/,://


:set autoindent
":set smartindent
"when smartindent is set, shell comments are always indented
"to column 0
:set autowrite
:ab bbs bigbluesync.sh
:ab jbs jandsync.sh
:ab lbs localbuildsync.sh
:ab lcbs localbuildconnsync.sh
:ab wbs winsync.sh
:ab sss sunsync.sh
:ab UPDINFO UDPINFO

"Below for \t tab alignments
":set shiftwidth=8
":set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab 
"Below for 4 space tab aligments
:set tabstop=4 softtabstop=4 shiftwidth=4
":set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab 
if has("autocmd")
    " For java files use \t as separator
"    autocmd BufRead,BufNewFile *.java :set shiftwidth=8 tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab 
    autocmd BufRead,BufNewFile *.js :set tabstop=8 softtabstop=4 shiftwidth=4
    autocmd BufRead,BufNewFile *.ts :set tabstop=8 softtabstop=4 shiftwidth=4
    autocmd BufRead,BufNewFile *.html :set tabstop=8 softtabstop=4 shiftwidth=4
"    autocmd BufRead,BufNewFile *.go :set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab 
    autocmd BufRead,BufNewFile /home/bhargava/github/kodi/* :set tabstop=8 softtabstop=2 shiftwidth=2 noexpandtab
    autocmd BufRead,BufNewFile /home/bhargava/bitbucket/useless-pvr/* :set tabstop=8 softtabstop=2 shiftwidth=2 noexpandtab
endif


:set hlsearch   " highlight search
:set number     " show line numbers - use :set nonumber to disable line numbers
:set incsearch  " search as you type

:command -nargs=* Make make <args> | cwindow 5
":map <F9> :w<CR>:Make %< <CR> <CR>
:map <F9> :make %< <CR>
:map <F8> :!./%< <CR>
:set cmdheight=2
"nmap <buffer> <CR> 0ye<C-W>w:tag <C-R>"<CR>z<CR><C-W><C-W># " press enter on tag name
"nmap <buffer> <CR> 0ye:! showgraph.sh <C-R>"  1 >/dev/null & <CR><CR>
:set showcmd
:set report=0
:set wildmode=list:longest
:set winheight=9999
:set so=5
:set ruler
":set mouse=a
:set laststatus=2
":imap <silent> ,, <ESC>"_yiw:s/\(\%#\w\+\)/<\1> <\/\1>/<cr><c-o><c-l>f>a

":nmap ll :cl<CR>
":nmap l; :cn<CR>
":nmap lk :cp<CR>
":nmap <F2> :'<,'>s/^/\/\/ /g<CR>

:function FoldComments()
":set foldmarker=/*,*/
":set foldmethod=marker
: silent! zx
:endfunction

:function FoldFunction()
":set foldmarker={,}
":set foldmethod=marker
: silent! zx
:endfunction

:function FindCalling()
:    let l:word = expand(expand("<cword>"))
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%f\ %m\ %l'
:    let &grepprg = 'findcalling.sh ' . l:word
:    write
:    silent! grep %
:    copen
:    redraw!
:    echo &grepprg 
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction

:function FindCalled()
:    let l:word = expand(expand("<cword>"))
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%f\ %m\ %l'
:    let &grepprg = 'findcalled.sh ' . l:word
:    write
:    silent! grep %
:    copen
:    redraw!
:    echo &grepprg 
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction

:function CommentEnable()
:	hi Constant   term=NONE      cterm=NONE ctermfg=darkred      gui=NONE guifg=red2
:	hi Comment    term=underline cterm=NONE ctermfg=darkgreen    gui=NONE guifg=green3
:endfunction

:function CommentDisable()
:	colorscheme default
:endfunction

	
:fun! DiffFile()
:    let lnum = line(".")
:    echohl ModeMsg
:    let line = getline(lnum)
:    echohl None
:    execute "!diff.sh " . line
":    system(" diff.sh" . line)
:endfun
":nmap <buffer> <CR> :call DiffFile()  <CR><CR>
":nmap <F12> <ESC>:qa<CR>

:function ShowFunc()
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
:    let &grepprg = 'ctags -x --language-force=c --c-types=f --sort=no -o -'
":    let &grepprg = 'ctags -x  --c-types=f --sort=no -o -'
:    write
:    silent! grep %
:    cwindow
:    redraw!
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction
:fun! ShowFuncName()
:    let lnum = line(".")
:    let col = col(".")
:    echohl ModeMsg
:    echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
:    echohl None
:    call search("\\%" . lnum . "l" . "\\%" . col . "c")
:endfun
:map .f :call ShowFuncName() <CR>
:map ..c :call FindCalling() <CR> <C-W> <C-W>
:map ..v :call FindCalled() <CR>  <C-W> <C-W>

:function! Myfun()
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
":    let &grepformat = '||\s\k*\s*%l\s%f\s%m'
:    let &grepprg = 'ctags -x --c-types=f --sort=no -o - --format=1'
:    write
:    silent! grep %
:    copen
:    redraw!
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction


:function PreviewHTML_TextOnly()
:    let l:fname = expand("%:p" )
:    new
:    set buftype=nofile nonumber
:    exe "%!lynx " . l:fname . " -dump -nolist -underscore :    -width " . winwidth( 0 )
: endfunction
:function! Mosh_html2text()
    :silent! %s/&lt;/</g
    :silent! %s/&gt;/>/g
    :silent! %s/&amp;/&/g
    :silent! %s/&quot;/"/g
    :silent! %s/&nbsp;/ /g
    :silent! %s/&ntilde;/\~/g
    :silent! %s/<P>//g
    :silent! %s/<BR>/ /g
    :silent! %s/</\?[BI]>/ /g
    :set readonly
:endfun
:function! Test()
:	cwindow
:endfunction


": spell corrections
:iabbrev teh the
:iabbrev aer are
:iabbrev etst test
:iabbrev shoudl should
:iabbrev lenght length
:iabbrev unxi unix
:iabbrev ofr for
:iabbrev disbale disable 
:iabbrev meida media
:iabbrev Meida Media
:iabbrev hte the
:iabbrev deivce device
:iabbrev optinos options
:iabbrev referenece reference
:iabbrev witdh width
:iabbrev ouput output
:iabbrev prinft printf
:iabbrev evn env
:iabbrev gruop group
:iabbrev updrestore udprestore
:iabbrev hcm hmc
:iabbrev hcmHost hmcHost
:iabbrev hcmLpar hmcLpar
:iabbrev iamge image
:iabbrev virutal virtual
:iabbrev strint string
:iabbrev startttime starttime
:iabbrev endttime endtime
:iabbrev socpe scope
:iabbrev theri their
:iabbrev remoivng removing
:iabbrev oepn open
:iabbrev mulit multi
:iabbrev mulitregion multiregion
:iabbrev uesd used
:iabbrev flase false

function! Mosh_FocusLost_SaveFiles() 
    :exe ":au FocusLost" expand("%") ":wa" 
endfunction 

set viminfo='10,\"100,:20,%,n~/.viminfo 
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endi

:call CommentEnable()

:set smartcase

filetype on
filetype plugin indent on
set nocp
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"autocmd FileType c set omnifunc=ccomplete#Complete
"autocmd FileType c set omnifunc=go#complete#Complete
"autocmd FileType c set omnifunc=go#complete#GocodeComplete


" OmniCppComplete
"set nocp
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
if version >= 700
   if has('insert_expand')
      let OmniCpp_NamespaceSearch   = 1
      let OmniCpp_GlobalScopeSearch = 1
      let OmniCpp_ShowAccess        = 1
      let OmniCpp_ShowPrototypeInAbbr = 1
      let OmniCpp_MayCompleteDot    = 1
      let OmniCpp_MayCompleteArrow  = 1
      let OmniCpp_MayCompleteScope  = 1
      let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

      if has('autocmd')
         " Automatically open/close the preview window.
         au CursorMovedI,InsertLeave * if pumvisible() == 0 | sil! pclose | endif
         set completeopt=menuone,menu,longest,preview
      endif
  endif
endif

set wildmode=longest,list
set wildmenu

if has("cscope")
	set csto=1
	set nocst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb
endif

set tags=tags;/
set tags+=~/.vim/tags/cpp_src
"helptags ~/.vim/doc 

"set ic                  "ignorecase comparison

set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType json setlocal equalprg=python\ -mjson.tool\ 2>/dev/null

"disable using of 8 spaces as tab
:set expandtab

"load pathogen
"execute pathogen#infect()

"open nerdtree (NERDTree) by default on start of vim
"autocmd vimenter * NERDTree
"autocmd VimEnter * wincmd p
:nmap <F4> :NERDTreeTabsToggle<CR>
:nmap <S-Space> <C-B>
:nmap <Space> <C-F>
":NERDTreeTabsToggle
"set NERDTreeWinPos="right"
syntax keyword Type     std::string 

" natural split opening http://robots.thoughtbot.com/post/48275867281/vim-splits-move-faster-and-more-naturally
set splitbelow
set splitright

" autoload cscope connections
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

" run below command to generate list of identifiers
" for syntax highlighting using ctags
" :UpdateTypesFile

" YouCompleteMe 
"let g:ycm_confirm_extra_conf = 0

" NeoComplete
"let g:neocomplete#enable_at_startup = 1

" eclim
"let g:EclimCompletionMethod = 'omnifunc'

" JavaImp.vim
let g:JavaImpPaths = "/home/bhargava/android/android-sdk-linux/sources/android-22,/home/bhargava/bitbucket/useless-tvapp/app/src/main/java"
let g:JavaImpDataDir = $HOME . "/.vim/JavaImp" 

" javacomplete plugin
" http://vim.sourceforge.net/scripts/script.php?script_id=1785
" FIXME: disabling complete for java, not working
"autocmd FileType java setlocal omnifunc=javacomplete#Complete
:inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P>
:inoremap <buffer> <C-S-Space> <C-X><C-U><C-P>
" To enable inserting class imports with F4, add:
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)
" To add all missing imports with F5:
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
" To remove all missing imports with F6:
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
let g:JavaComplete_SourcesPath = "/home/bhargava/android/android-sdk-linux/sources/android-22"
let g:JavaComplete_LibsPath = "/home/bhargava/android/android-sdk-linux/platforms/android-22"
let g:JavaComplete_JavaviDebug = "1"

" vim-javascript-syntax
au FileType javascript call JavaScriptFold()

" https://github.com/leafgarland/typescript-vim
" vim typescript
let g:typescript_indent_disable = 1

"You can use the 'formatoptions' option  to influence how Vim formats text.
"'formatoptions' is a string that can contain any of the letters below.  The
"default setting is "tcq".  You can separate the option letters with commas for
"readability.

"letter  meaning when present in 'formatoptions'
"
"t       Auto-wrap text using textwidth
"c       Auto-wrap comments using textwidth, inserting the current comment
"        leader automatically.
"r       Automatically insert the current comment leader after hitting
"        <Enter> in Insert mode.
"o       Automatically insert the current comment leader after hitting 'o' or
"        'O' in Normal mode.
":autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
:autocmd FileType c,h,cpp set formatoptions=tcq
:set formatoptions=tcq

":function XmlFormat()
":%!xmllint --format %
":endfunction
:command XmlFormat %!xmllint --format %
