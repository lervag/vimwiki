source ../init.vim

let g:wiki_root = g:testroot . '/wiki-basic'
let g:wiki_journal = {'name' : 'diary'}
runtime plugin/wiki.vim

bwipeout!
silent call wiki#journal#make_note()
call wiki#test#assert(b:wiki.in_journal)

bwipeout!
let g:wiki_journal.date_format.daily = '%d.%m.%Y'
let s:date = strftime(g:wiki_journal.date_format[g:wiki_journal.frequency])
silent call wiki#journal#make_note()
call wiki#test#assert_equal(s:date, expand('%:t:r'))

let s:step = index(sort(['01.02.2019', s:date]), s:date)
      \ ? -1 : 1
silent call wiki#journal#go(s:step)
call wiki#test#assert_equal('01.02.2019', expand('%:t:r'))

silent bwipeout!
let g:wiki_journal.frequency = 'weekly'
let s:date = strftime(g:wiki_journal.date_format[g:wiki_journal.frequency])
silent call wiki#journal#make_note()
call wiki#test#assert_equal(expand('%:t:r'), s:date)
silent call wiki#journal#go(-1)
call wiki#test#assert_equal(expand('%:t:r'), '2019_w02')

silent bwipeout!
let g:wiki_journal.frequency = 'monthly'
let s:date = strftime(g:wiki_journal.date_format[g:wiki_journal.frequency])
silent call wiki#journal#make_note()
call wiki#test#assert_equal(expand('%:t:r'), s:date)
silent call wiki#journal#go(-1)
call wiki#test#assert_equal(expand('%:t:r'), '2019_m02')

if $QUIT | quitall! | endif
