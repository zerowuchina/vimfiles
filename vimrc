let mapleader = ";"    " 比较习惯用;作为命令前缀，右手小拇指直接能按到
" 把空格键映射成:
" nmap <space> :

" 快捷打开编辑vimrc文件的键盘绑定"
map <silent> <leader>ee :e $MYVIMRC<cr>
"map <silent> <leader>ee :e $VIM/vimfiles/.vimrc<cr>
" autocmd! bufwritepost *.vimrc source $HOME/.vimrc

" 判断操作系统
if (has("win32") || has("win64"))
    let g:isWin = 1
else
    let g:isWin = 0
endif

" 判断是终端还是gvim
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

set nocompatible    " 关闭兼容模式
filetype off
if (!g:isWin)
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
else
    set rtp+=$VIM/vimfiles/bundle/vundle/
    call vundle#begin('$VIM/vimfiles/bundle')
endif

Bundle 'VundleVim/Vundle.vim'
" vim-script repos
"Bundle 'bufexplorer.zip'
Bundle 'vimcdoc'
Bundle 'Align'
"Bundle 'taglist.vim'
"Bundle 'cscope.vim'
Bundle 'TabBar'
Bundle 'Emmet.vim'
Bundle 'EasyMotion'
Bundle 'Auto-Pairs'
Bundle 'unimpaired.vim'
Bundle 'OmniCppComplete'
Bundle 'The-NERD-tree'
Bundle 'The-NERD-Commenter'
Bundle 'abolish.vim'
Bundle 'closetag.vim'
Bundle 'surround.vim'
call vundle#end()

syntax enable       " 语法高亮
filetype plugin on  " 文件类型插件
filetype indent on
set shortmess=atI   " 去掉欢迎界面
set autoindent
autocmd BufEnter * :syntax sync fromstart
set clipboard=unnamed
set nu              " 显示行号
set showcmd         " 显示命令
set lz              " 当运行宏时，在命令执行完成之前，不重绘屏幕
set hid             " 可以在没有保存的情况下切换buffer
set backspace=eol,start,indent
set whichwrap+=<,>,h,l " 退格键和方向键可以换行
set incsearch       " 增量式搜索
"set nohlsearch
set hlsearch        " 高亮搜索
set ignorecase      " 搜索时忽略大小写
set smartcase
set magic           " 额，自己:h magic吧，一行很难解释
set showmatch       " 显示匹配的括号
set nobackup        " 关闭备份
set nowb
set noswapfile      " 不使用swp文件，注意，错误退出后无法恢复
set lbr             " 在breakat字符处而不是最后一个字符处断行
set autoindent      " 自动缩进
set smartindent     " 智能缩进
set cindent         " C/C++风格缩进
set wildmenu
set nofen
set fdl=10

" tab转化为4个字符
set noexpandtab
set smarttab
set shiftwidth=4
set tabstop=4

" 不使用beep或flash
set vb t_vb=

set background=dark
set t_Co=256
colorscheme desert

set history=256  " vim记住的历史操作的数量，默认的是20
set autoread     " 当文件在外部被修改时，自动重新读取
set mouse=n     " 在所有模式下都允许使用鼠标，还可以是n,v,i,c等

"在gvim中高亮当前行
if (g:isGUI)
    " 设置窗口大小
    " 窗口宽度
    set columns=99
    " 窗口高度
    set lines=25

    set cursorline
    colorscheme wombat
    hi cursorline guibg=#333333
    hi CursorColumn guibg=#333333
    if (g:isWin)
        set guifont=Consolas:h10
        "set guifont=YaHei\ Consolas\ Hybrid:h10

        set encoding=utf-8
		set fileencodings=utf-8,gb2312,ucs-bom,euc-cn,euc-tw,gb18030,gbk,cp936
    	source $VIMRUNTIME/delmenu.vim
		source $VIMRUNTIME/menu.vim
		"set langmenu=zh_CN.utf-8
    	language messages zh_cn.utf-8

    else
        set guifontwide=Consolas\ 10
        "set guifont=DejaVu\ Sans\ Mono\ 10
        "set gfw=DejaVu\ Sans\ Mono\ 10

        set encoding=utf8
    	set fileencodings=utf8,gb2312,gb18030,ucs-bom,latin1

    endif
    " 不显示toolbar
    set guioptions-=T
    " 不显示菜单栏
    "set guioptions-=m
else
    "在命令行中运行
    "colorscheme default
    colorscheme desert
	let &termencoding=&encoding
	set fileencodings=utf8,gb2312,gb18030,gbk,cp936,ucs-bom,latin1
endif


" 状态栏
set laststatus=2      " 总是显示状态栏
set listchars=tab:>-,trail:.,extends:>,precedes:<,eol:¶
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" 获取当前路径，将$HOME转化为~
function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfunction
set statusline=[%n]\ %F%m%r%h\ \|%=\|\ %l,%c\ %p%%\ \|\ ascii=%b,hex=%B%{((&fenc==\"\")?\"\":\"\ \|\ \".&fenc)}

" 第80列往后加下划线
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

autocmd FileType java comp javac
autocmd filetype cs compile cs

" 根据给定方向搜索当前光标下的单词，结合下面两个绑定使用
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'b'
        execute "normal ?" . l:pattern . "<cr>"
    else
        execute "normal /" . l:pattern . "<cr>"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" 用 */# 向 前/后 搜索光标下的单词
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" 在文件名上按gf时，在新的tab中打开
"map gf :tabnew <cfile><cr>

" 用c-j,k在buffer之间切换
nn <C-J> :bn<cr>
nn <C-K> :bp<cr>


"从系统剪切板中复制，剪切，粘贴
map <F7> "+y
map <F8> "+x
map <F9> "+p

" 恢复上次文件打开位置
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" 删除buffer时不关闭窗口
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction


" 插件窗口的宽度，如TagList,NERD_tree等，自己设置
let s:PlugWinSize = 25

" taglist.vim
" http://www.vim.org/scripts/script.php?script_id=273
" <leader>t 打开TagList窗口，窗口在右边
nmap <silent> <leader>t :TlistToggle<cr>
"let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 0
let Tlist_WinWidth = s:PlugWinSize
let Tlist_Auto_Open = 0
let Tlist_Display_Prototype = 0
"let Tlist_Close_On_Select = 1


" OmniCppComplete.vim
" http://www.vim.org/scripts/script.php?script_id=1520
set completeopt=menu
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_DefaultNamespaces = ["std"]     " 逗号分割的字符串
let OmniCpp_MayCompleteScope = 1
let OmniCpp_ShowPrototypeInAbbr = 0
let OmniCpp_SelectFirstItem = 2
" c-j自动补全，当补全菜单打开时，c-j,k上下选择
"imap <expr> <c-j>      pumvisible()?"\<C-N>":"\<C-X><C-O>"
"imap <expr> <c-k>      pumvisible()?"\<C-P>":"\<esc>"
" f:文件名补全，l:行补全，d:字典补全，]:tag补全
imap <C-]>             <C-X><C-]>
imap <C-F>             <C-X><C-F>
imap <C-D>             <C-X><C-D>
imap <C-L>             <C-X><C-L>

" NERD_commenter.vim
" http://www.vim.org/scripts/script.php?script_id=1218
" Toggle单行注释/“性感”注释/注释到行尾/取消注释
map <leader>cc ,c<space>
map <leader>cs ,cs
map <leader>c$ ,c$
map <leader>cu ,cu

" NERD tree
" http://www.vim.org/scripts/script.php?script_id=1658
let NERDTreeShowHidden = 1
let NERDTreeWinPos = "left"
let NERDTreeWinSize = s:PlugWinSize
nmap <leader>n :NERDTreeToggle<cr>


" 更新ctags和cscope索引
" href: http://www.vimer.cn/2009/10/把vim打造成一个真正的ide2.html
" 稍作修改，提取出DeleteFile函数，修改ctags和cscope执行命令
map <F6> :call Do_CsTag()<cr>
function! Do_CsTag()
    let dir = getcwd()

    "先删除已有的tags和cscope文件，如果存在且无法删除，则报错。
    if ( DeleteFile(dir, "tags") )
        return
    endif
    if ( DeleteFile(dir, "cscope.files") )
        return
    endif
    if ( DeleteFile(dir, "cscope.out") )
        return
    endif

    if(executable('ctags'))
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:isWin)
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        else
            silent! execute "!find . -iname '*.[ch]' -o -name '*.cpp' > cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
    " 刷新屏幕
    execute "redr!"
endfunction

function! DeleteFile(dir, filename)
    if filereadable(a:filename)
        if (g:isWin)
            let ret = delete(a:dir."\\".a:filename)
        else
            let ret = delete("./".a:filename)
        endif
        if (ret != 0)
            echohl WarningMsg | echo "Failed to delete ".a:filename | echohl None
            return 1
        else
            return 0
        endif
    endif
    return 0
endfunction

" cscope 绑定
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
    " s: C语言符号  g: 定义     d: 这个函数调用的函数 c: 调用这个函数的函数
    " t: 文本       e: egrep模式    f: 文件     i: include本文件的文件
    nmap <leader>ss :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <leader>sg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>sc :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <leader>st :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <leader>se :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
    nmap <leader>si :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
    nmap <leader>sd :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
endif

" Quick Fix 设置
map <F3> :cw<cr>
map <F4> :cp<cr>
map <F5> :cn<cr>

" 移单行
nmap <C-Up> [e
nmap <C-Down> ]e

" 移多行
vmap <C-Up> [egv
vmap <C-Down> ]egv
nmap gV '[v']

" let g:AutoPairsFlyMode = 1
let g:fencview_autodetect=1
let g:fencivew_auto_patterns="*"
