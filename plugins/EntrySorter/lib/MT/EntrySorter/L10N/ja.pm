package MT::EntrySorter::L10N::ja;

use strict;
use utf8;
use base 'MT::EntrySorter::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Interval Seconds' => '日時の間隔(秒)',
    'If newest entry date is 2017-01-09 22:16:00 and the interval is 3600, entries date will updated 2017-01-09 22:16:00, 2017-01-09 21:16:00, 2017-01-09 20:16:00, ...'
        => 'もし最新の記事の公開日時が2017-01-09 22:16:00で、この間隔に3600(1時間)を設定したら、記事の公開日時は2017-01-09 22:16:00, 2017-01-09 21:16:00, 2017-01-09 20:16:00, ...という日時に更新されます。',
    'Sort Entries' => '記事を並べ替える',
    'Update Entries Date' => '並べ替えに沿って公開日を更新する',
    'Cancel Sorting' => '並べ替えをキャンセルする',
    'Entried date updated successfully.' => '記事の公開日が更新されました。',
    'Are you sure to update entries date?' => '記事の日付を更新します。よろしいですか？',
    'There are no entries to sort.' => '並べ替えを行う記事が1件もありません。',
);

1;
