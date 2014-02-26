" Xcomments <xcomments.vim>
"
"         HINT: ��ǰ����֧�ֺ������е�ע�� 
"
" Script Info and Document  {{{
"=============================================================================
"    Copyright: Copyright (C) 2012 �ž� <xjiujiu@foxmail.com> 
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               Xcomments.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damamges
"               resulting from the use of this software.
"     Linsence: BSD NEW
" Name Of File: Xcomments.vim
"  Description: Code Comment Vim Plugin
"   Maintainer: �ž� <xjiujiu@foxmail.com>
"          URL: http://www.vim.org/scripts/script.php?script_id=3941    
"  Last Change: 2012.02.16 
"      VERSION: $Id: Xcomments.vim 88 2012-05-20 06:15:48Z xjiujiu@gmail.com $
"        Usage: Please see these examples on the blow.
"file comment example
"//f - <C-M>
"===> {{{
"/**
" * @version $Id: Xcomments.vim 88 2012-05-20 06:15:48Z xjiujiu@gmail.com $
" * @package: None
" * @subpackage: None
" * @copyRight: Copyright (c) 2011-2012 http://www.xjiujiu.com.All right reserved
" * @license: Apache GNU
" */
" }}}
"//////////////////////////////////////////
"class comment example
"//c - <C-M>
" ===> {{{
"/**
" * @point
" * 
" * @desc
" * 
" * @author �ž� <xjiujiu@foxmail.com>
" * @package None
" * @version $Id: Xcomments.vim 88 2012-05-20 06:15:48Z xjiujiu@gmail.com $
" */
" }}}
"//////////////////////////////////////////
"Method Or Function comment example
"//m - <C-M>
"function GetName(string test, int yes)
"===> {{{
"/**
" * @point
" * 
" * @desc
" * 
" * @access public
" * @param string test
" * @param int yes
" * @return void
" * @throws none
" */
"function GetName(string test, int yes)
"}}}
"//////////////////////////////////////////
"Variable comment example
"//v - <C-M>
"$string     = "test"
"===> {{{
"/**
" * var $string     
" */
"$string     = "test"
"}}}
"
"//////////////////////////////////////////
"�����Լ���ע��ȫ��������Ϣʾ��
"let g:myCodeCommenterConfigItems  = {
"            \ 'author': 'xjiujiu',                         ==> To config the author of these code 
"            \ 'siteUrl': 'http://www.xjiujiu.com',         ==> To config the site of the author 
"            \ 'email': 'xjiujiu@foxmail.com',              ==> To config the email of the author 
"            \ 'linsence': 'BSD NEW',                       ==> To config the code linsence 
"            \ 'copyright': 'Copyright (c) 2011-2012 http://www.xjiujiu.com.All right reserved',    ==> To config the copyright information 
"            \ 'companyName': 'HongJuZi',                   ==> Your company name 
"            \ 'projectDecription': 'HongJuZi Framework',   ==> To config the decsription of the project 
"            \ 'since': '1.0.0',                            ==> To config the decsription of the project 
"            \ 'versionBySvn': 1                            ==> To config the version of the file is gen by subversion or by the script function
"            \ }
"
"=============================================================================
" }}}

"//////////////////////////////////////////
"��ݼ�����
noremap <C-M>  :call WriteComment()<CR>

"//////////////////////////////////////////
"ȫ�ֱ�������
let s:codeCommenterConfigItems  = {
            \ "author": "��������",
            \ "email": "��������",
            \ "linsence": "��Ȩ��Ϣ",
            \ "siteUrl": "������վ",
            \ "copyright": "�汾��Ϣ",
            \ "companyName": "��˾����", 
            \ "projectDecription": "��Ŀ����",
            \ "since": "1.0.0",
            \ "versionBySvn": 1
            \ } 
if exists('g:myCodeCommenterConfigItems')
    for item in keys(s:codeCommenterConfigItems)
        if has_key(g:myCodeCommenterConfigItems, item)
            let s:codeCommenterConfigItems[item]    = g:myCodeCommenterConfigItems[item]
        endif
    endfor
endif

"//////////////////////////////////////////
"���뷶Χ���õı�������
let s:currentLine   = 0 
let s:commentMask   = "*"
let s:indent        = ''
let s:TAB           = "\t"

"//////////////////////////////////////////
"��������
function! WriteComment()
    let commentList     = []
    let s:currentLine   = line(".")
    let commentType     = s:GetCurrentLineContent()
    let s:indent        = s:GetIndentWidth(commentType)
    call s:GetCommentMask() 
    if commentType  =~ "//f"
        let commentList += s:GetFileComment()
    elseif commentType =~ "//c"
        let commentList += s:GetClassComment()
    elseif commentType =~ "//m"
        let commentList += s:GetMethodComment()
    elseif commentType =~ "//v"
        let commentList += s:GetVariableComment()
    elseif commentType =~ "//i"
        let commentList += s:GetInhertDocComment()
    endif
    if !empty(commentList)
        let commentList     = s:GetHeader() + commentList
        let commentList     += s:GetFooter()
        call setline(".", "")
        for comment in commentList
            call s:AppendContext(comment)
        endfor
    endif
endfunction

"/////////////////////////////////////////////////////////////////
"�õ��ļ���ע������
function! s:GetFileComment()
    let fileComment     = [
                        \ s:GetVersionInfo(), 
                        \ s:GetAuthor(),
                        \ s:GetProjectDescription(),
                        \ s:GetCopyRight()
                        \ ]
    return fileComment
endfunction

"�õ��汾��Ϣע��
function! s:GetVersionInfo()
    if s:codeCommenterConfigItems['versionBySvn'] == 1
        return " " . s:commentMask . " @version" .
               \ " $Id" . "$"
    let versionInfo     = " " . s:commentMask . " @version " .
                          \ . "$Id"
    let versionInfo     .= s:GetFileName() . " " 
    let versionInfo     .= s:GetSvnVersionNum() . " " 
    let versionInfo     .= s:GetCurrentTime()   . " " 
    let versionInfo     .= s:author . " $"
    return versionInfo
endfunction

"""
 " �õ��ļ�����ʱ�� 
 " 
 " ���ص�ǰ�ļ�������ʱ�� 
 " 
 " @access public
 " @return void
"""
function! s:GetAuthor()
    return " " . s:commentMask . " @author " . 
           \ s:GetCurrentTime() . " By " . s:codeCommenterConfigItems['author']
endfunction

"""
 "�õ�Svn�汾��
 " 
 " ���ص�ǰ�ļ�Svn�İ汾�� 
 " 
 " @access public
 " @return void
"""
function! s:GetSvnVersionNum()
    return " " . s:commentMask . " @version " . "1.0.0"
endfunction

"�õ���ǰʱ��
function! s:GetCurrentTime()
    if exists("*strftime")
        return strftime("%c")
    else
        return localtime()
    endif
endfunction

"�õ�����
function! s:GetPackage()
    return " " . s:commentMask . " @package " . "None"
endfunction

"�õ��Ӱ���
function! s:GetSubpackage()
    return " " . s:commentMask . " @subpackage " . "None"
endfunction

"�õ���Ȩ��Ϣ
function! s:GetCopyRight()
    return " " . s:commentMask . " @copyright " .
           \ s:codeCommenterConfigItems['copyright']
endfunction

"�õ�Э��ע��
function! s:GetLicense()
    return " " . s:commentMask . " @license " .
           \ s:codeCommenterConfigItems['linsence']
endfunction

"�õ�����������Ϣ
function! s:GetProjectDescription()
    return " " . s:commentMask . " @description " . s:codeCommenterConfigItems['projectDecription']
endfunction

"/////////////////////////////////////////////////////////////////
"�õ����ע��
function! s:GetClassComment()
    let classComment    = [
                        \ " " . s:commentMask . " @point",
                        \ s:GetBlackLine(),
                        \ " " . s:commentMask . " @desc",
                        \ s:GetBlackLine(),
                        \ s:GetAuthor(),
                        \ s:GetPackage(),
                        \ s:GetSince()
                        \ ]
    return classComment
endfunction

"�õ�����ע��
function! s:GetAuthor()
    return " " . s:commentMask . " @author " .
           \ s:codeCommenterConfigItems['author'] .
           \ " <" . s:codeCommenterConfigItems['email'] . ">"
endfunction
"/////////////////////////////////////////////////////////////////
"�õ�������ע��
function! s:GetMethodComment()
    let languages   = {
                    \ "php": 1,
                    \ "js": 1, 
                    \ "vim": 1, 
                    \ "py": 1,
                    \ "as": 2,
                    \ "cs": 2,
                    \ "cpp": 2,
                    \ "java": 2,
                    \ "c": 2
                    \ }
    if has_key(languages, s:GetFileExt())
        let methodCode  = getline(s:currentLine + 1)
        if languages[s:GetFileExt()] == 2 
            return s:GetTypeMethodComment(methodCode) 
        endif
        return s:GetNoTypeMethodComment(methodCode)
    endif
    return [" " . s:commentMask . " Sorry the file type cann't be supproted��"]
endfunction

"�õ������ͱ�ʶ�ĺ���ע��
function! s:GetTypeMethodComment(methodCode)
    let typeMethodComment   = [
                            \ " " . s:commentMask . " @point",
                            \ s:GetBlackLine(),
                            \ " " . s:commentMask . " @desc",
                            \ s:GetBlackLine(),
                            \ s:GetAuthor(),
                            \ s:GetAccess(a:methodCode)]
    let typeMethodComment   += s:GetParams(a:methodCode)
    let typeMethodComment   += [s:GetReturn(),
                            \ s:GetException()
                            \ ]
    return typeMethodComment
endfunction

"�õ�û�����ͱ�ʶ�ĺ���ע��
function! s:GetNoTypeMethodComment(methodCode)
    let noTypeMethodComment     = [
                                \ " " . s:commentMask . " @point",
                                \ s:GetBlackLine(),
                                \ " " . s:commentMask . " @desc",
                                \ s:GetBlackLine(),
                                \ s:GetAuthor(),
                                \ s:GetAccess(a:methodCode)]
    let noTypeMethodComment     += s:GetParams(a:methodCode)
    let noTypeMethodComment     += [s:GetReturn(),
                                \ s:GetException()
                                \ ]
    return noTypeMethodComment
endfunction

"�õ������Ե�ע��
function! s:GetAccess(methodCode)
    let access      = " " . s:commentMask . " @access "
    if match(a:methodCode, "private") != -1
        let access  .= "private"
    elseif match(a:methodCode, "protected") != -1
        let access  .= "protected"
    else
        let access  .= "public"
    endif
    if match(a:methodCode, "static") != -1
        let access  .= " static"
    endif
    return access
endfunction

"�õ�������Ϣע��
function! s:GetParams(methodCode)
    let params      = [] 
    let i           = match(a:methodCode, "\(") + 1
    let len         = len(a:methodCode)
    let methodName  = ""
    while i < len
        let word  = a:methodCode[i]
        if word == ","
            let params  += [" " . s:commentMask . " @param " . methodName] 
            let methodName  = ""
        elseif word == ")"
            if methodName != ""
                let params  += [" " . s:commentMask . " @param " . methodName]
            endif
            break
        else 
            let methodName .= word
        endif
        let i       += 1 
    endwhile
    return params
endfunction

"�õ���汾��Ϣע��
function! s:GetSince()
    return " " . s:commentMask . " @since " .
                \ s:codeCommenterConfigItems['since']
endfunction

"�õ�������Ϣע��
function! s:GetReturn()
    return " " . s:commentMask . " @return void"
endfunction

"�õ��쳣��Ϣע��
function! s:GetException()
    return " " . s:commentMask . " @throws none"
endfunction

"////////////////////////////////////////////////////////////
"�õ��Ա�����ע��
function! s:GetVariableComment()
    let variableComment     = " " . s:commentMask . " @var "
    let i       = 0
    let hasChar = 0
    let varCode = getline(s:currentLine + 1)
    let length  = len(varCode)
    while i < length
        let char    = varCode[i]
        let i       += 1
        if char == "=" || char == ";" || char == "\r" || char == "\n"
            break
        elseif char == ' ' && hasChar == 0 
            continue
        else
            let variableComment     .= char
            let hasChar             = 1
        endif
    endwhile
    return [variableComment]
endfunction

"////////////////////////////////////////////////////////////
"�õ��Լ̳е�ע��
function! s:GetInhertDocComment()
    let inhertdocComment   = [
                            \ " " . s:commentMask . " @point",
                            \ s:GetBlackLine(),
                            \ " " . s:commentMask . " @desc",
                            \ s:GetBlackLine(),
                            \ " " . s:commentMask . " {@inheritdoc}",
                            \ s:GetBlackLine(),
                            \ s:GetAuthor(),
                            \ ]
    return inhertdocComment
endfunction

"////////////////////////////////////////////////////////////
"�õ���ǰ�е�����
function! s:GetCurrentLineContent()
    return getline(".")
endfunction

"�õ��ļ���
function! s:GetFileName()
    return expand("%:t")
endfunction

"�õ��ļ���չ��
function! s:GetFileExt()
    if &ft == "javascript"
        return "js"
    endif
    return &ft 
endfunction

"���ע��ͷ��
function! s:GetHeader()
    if s:commentMask  == "*"
        return ["/**"]
    endif
    return ["\"\"\""]
endfunction

"���ע�͵Ĺ�������
function! s:GetCommon()
    return [" " . s:commentMask]
endfunction

"�õ�β��ע��
function! s:GetFooter()
    if s:commentMask == "*"
        return [" " . s:commentMask . "/"]
    endif
    return ["\"\"\""]
endfunction

"�õ�����ע��
function! s:GetBlackLine()
    return " " . s:commentMask . " "
endfunction

function! s:GetCommentMask()
    let commentMasks    = {
                        \ "php": "*",
                        \ "js": "*",
                        \ "as": "*",
                        \ "cs": "*",
                        \ "cpp": "*",
                        \ "java": "*",
                        \ "c": "*",
                        \ "py": "\"",
                        \ "vim": "\""
                        \ }
    if has_key(commentMasks, s:GetFileExt())
        let s:commentMask   =  commentMasks[s:GetFileExt()]
    else
        let s:commentMask       = "*"
    endif
endfunction

"""
 " �õ���ǰ�е������� 
 " 
 " ͨ���Ե�ǰ�пո��ͳ�ƣ��õ���ǰ����ʵ�������� 
 " 
 " @access public
 " @return void
"""
function! s:GetIndentWidth(string)
    let indent  = '' 
    let i       = 0
    let len     = len(a:string)
    while i < len
        if a:string[i] != ' '
            break
        else
            let indent .= ' ' 
        endif
        let i   += 1
    endwhile

    return indent
endfunction

"////////////////////////////////////////////////////////////
"���ע�͵����ݵ��ļ���
function! s:AppendContext(context)
    if a:context == ""
        return
    elseif a:context == "\n"
        call append(s:currentLine, s:indent . s:currentLine)
    else 
        call append(s:currentLine, s:indent . a:context)
    endif
    let s:currentLine     = s:currentLine + 1
endfunction
