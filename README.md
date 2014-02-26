xcomments
=========

This is a littile plugin of vim, it's support php/java/python/javascript comments.Welcome to use it, join it :D

# file comment example
> //f - &lt;C-M&gt; 

> ===>

> /**

>  \* @version $Id: Xcomments.vim 88 2012-05-20 06:15:48Z xjiujiu@gmail.com $

>  \* @package: None

>  \* @copyRight: Copyright (c) 2011-2012 http://www.xjiujiu.com.All right reserved

>  \* @license: Apache GNU

>  \*/

>  

# class comment example
> //c - &lt;C-M&gt;

>  ===>

> /**

>  \* @point

>  \* 

>  \* @desc

>  \* 

>  \* @author 九九 <xjiujiu@foxmail.com>

>  \* @package None

>  \* @version $Id: Xcomments.vim 88 2012-05-20 06:15:48Z xjiujiu@gmail.com $

>  \*/

>  

# Method Or Function comment example
> //m - &lt;C-M&gt;

> function GetName(string test, int yes)

> ===>

> /**

>  \* @point

>  \* 

>  \* @desc

>  \* 

>  \* @access public

>  \* @param string test

>  \* @param int yes

>  \* @return void

>  \* @throws none

>  \*/

> function GetName(string test, int yes)



# Variable comment example
> //v - &lt;C-M&gt;

> $string     = "test"

> ===>

> /**

>  \* var $string     

>  \*/

> $string     = "test"

> 

# 定义自己的注释全局配置信息示例
> let g:myCodeCommenterConfigItems  = {

>             \ 'author': 'xjiujiu',                         ==> To config the author of these code 

>             \ 'siteUrl': 'http://www.xjiujiu.com',         ==> To config the site of the author 

>             \ 'email': 'xjiujiu@foxmail.com',              ==> To config the email of the author 

>             \ 'linsence': 'BSD NEW',                       ==> To config the code linsence 

>             \ 'copyright': 'Copyright (c) 2011-2012 http://www.xjiujiu.com.All right reserved',    ==> To config the copyright information 

>             \ 'companyName': 'HongJuZi',                   ==> Your company name 

>             \ 'projectDecription': 'HongJuZi Framework',   ==> To config the decsription of the project 

>             \ 'since': '1.0.0',                            ==> To config the decsription of the project 

>             \ 'versionBySvn': 1                            ==> To config the version of the file is gen by subversion or by the script function

>             \ }

> 

> =============================================================================

>  

>

# "快捷键配置
> noremap &lt;C-M&gt;  :call WriteComment()<CR>
