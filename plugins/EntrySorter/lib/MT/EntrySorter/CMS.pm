package MT::EntrySorter::CMS;

use strict;
use warnings;

use MT::Util qw(ts2epoch epoch2ts);
use MT::EntrySorter::Util;

sub method_update {
    my ( $app ) = @_;
    my $q = $app->param;
    my $blog = $app->blog || die $app->translate("Invalid request");
    my @ids = split(/\s*,\s*/, $q->param('ids') || '');
    die $app->translate("Invalid request") unless @ids;

    my $perm = $app->user->permissions( $blog->id )
        or $app->translate("Invalid request");
    return $app->permission_denied() unless $perm->can_do('edit_all_entries');

    my $config = plugin_config($blog ? $blog->id : 0);
    my $interval = $config->{interval_seconds};

    my $terms = { id => \@ids };
    $terms->{blog_id} = $blog->id if $blog;

    my @entries = MT->model('entry')->load($terms, { sort => 'authored_on', direction => 'descend' });
    if ( scalar @entries > 0 ) {
        my %dict = map { $_->id => $_ } @entries;
        my $dt = ts2epoch($blog, $entries[0]->authored_on);
        foreach my $id ( @ids ) {
            my $entry = $dict{$id} || next;
            $entry->authored_on(epoch2ts($blog, $dt));
            $entry->save;
            $dt -= $interval;
        }
    }

    my $url = $q->param('return_to');
    $url =~ s/[\?&]entry_sorter_success=1//;
    $url .= '&entry_sorter_success=1';
    $app->redirect($url);
}

sub cb_template_param_list_common {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $blog = $app->blog || return;

    my $perm = $app->user->permissions( $blog->id )
        or return;
    return unless $perm->can_do('edit_all_entries');

    if ( $app->param('_type') =~ /^(entry|page)$/ ) {
        my $node = $tmpl->createElement('setvarblock', { name => 'content_header', append => 1 });
        $node->innerHTML(q{
            <__trans_section component="EntrySorter">
            <ul id="content-actions" class="action-link-list">
                <li>
                    <a href="javascript:void(0)" id="entry-sorter-start" class="icon-left icon-move" data-no-entries="<__trans phrase='There are no entries to sort.' />"><__trans phrase="Sort Entries" /></a>
                    <a href="<mt:var name='entry_sorter_update_uri' escape='html' />" id="entry-sorter-update" class="button" data-confirm="<__trans phrase='Are you sure to update entries date?' />" style="display: none"><__trans phrase="Update Entries Date" /></a>
                    <a href="javascript:void(0)" id="entry-sorter-cancel" class="icon-left icon-error" style="display: none"><__trans phrase="Cancel Sorting" /></a>
                </li>
            </ul>
            </__trans_section>
        });
        my $header = $tmpl->getElementById('header_include');
        $tmpl->insertBefore($node, $header);

        $param->{entry_sorter_update_uri} = $app->uri(
            mode => 'entry_sorter_update',
            args => {
                blog_id => $param->{blog_id},
                return_to => $ENV{REQUEST_URI} || $ENV{PATH_INFO},
            },
        );

        $param->{jq_js_include} ||= '';
        $param->{jq_js_include} .= plugin->load_tmpl('tmpl/entry-sorter.js')->text;
    }

    {
        my $node = $tmpl->createElement('setvarblock', { name => 'system_msg', append => 1 });
        $node->innerHTML(<<'TMPL');
            <__trans_section component="EntrySorter">
            <mt:if name="entry_sorter_success">
                <mtapp:statusmsg id="entry_sorter_success" class="success">
                    <__trans phrase="Entried date updated successfully." />
                </mtapp:statusmsg>
            </mt:if>
            </__trans_section>
TMPL
        my $header = $tmpl->getElementById('header_include');
        $tmpl->insertBefore($node, $header);

        $param->{entry_sorter_success} = $app->param('entry_sorter_success');
    }

    1;
}

1;
