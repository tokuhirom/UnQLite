package UnQLite;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";
our $rc = 0;

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

sub rc { $UnQLite::rc }

sub errstr {
    my $self = shift;
    if ($rc==UnQLite::UNQLITE_OK()) { return "UNQLITE_OK" }
    if ($rc==UNQLITE_NOMEM()) { return "UNQLITE_NOMEM" }
    if ($rc==UNQLITE_ABORT()) { return "UNQLITE_ABORT" }
    if ($rc==UNQLITE_IOERR()) { return "UNQLITE_IOERR" }
    if ($rc==UNQLITE_CORRUPT()) { return "UNQLITE_CORRUPT" }
    if ($rc==UNQLITE_LOCKED()) { return "UNQLITE_LOCKED" }
    if ($rc==UNQLITE_BUSY()) { return "UNQLITE_BUSY" }
    if ($rc==UNQLITE_DONE()) { return "UNQLITE_DONE" }
    if ($rc==UNQLITE_PERM()) { return "UNQLITE_PERM" }
    if ($rc==UNQLITE_NOTIMPLEMENTED()) { return "UNQLITE_NOTIMPLEMENTED" }
    if ($rc==UNQLITE_NOTFOUND()) { return "UNQLITE_NOTFOUND" }
    if ($rc==UNQLITE_NOOP()) { return "UNQLITE_NOOP" }
    if ($rc==UNQLITE_INVALID()) { return "UNQLITE_INVALID" }
    if ($rc==UNQLITE_EOF()) { return "UNQLITE_EOF" }
    if ($rc==UNQLITE_UNKNOWN()) { return "UNQLITE_UNKNOWN" }
    if ($rc==UNQLITE_LIMIT()) { return "UNQLITE_LIMIT" }
    if ($rc==UNQLITE_EXISTS()) { return "UNQLITE_EXISTS" }
    if ($rc==UNQLITE_EMPTY()) { return "UNQLITE_EMPTY" }
    if ($rc==UNQLITE_COMPILE_ERR()) { return "UNQLITE_COMPILE_ERR" }
    if ($rc==UNQLITE_VM_ERR()) { return "UNQLITE_VM_ERR" }
    if ($rc==UNQLITE_FULL()) { return "UNQLITE_FULL" }
    if ($rc==UNQLITE_CANTOPEN()) { return "UNQLITE_CANTOPEN" }
    if ($rc==UNQLITE_READ_ONLY()) { return "UNQLITE_READ_ONLY" }
    if ($rc==UNQLITE_LOCKERR()) { return "UNQLITE_LOCKERR" }
}

sub cursor_init {
    my $self = shift;
    bless [$self->_cursor_init(), $self], 'UnQLite::Cursor';
}

package UnQLite::Cursor;

sub first_entry {
    my $self = shift;
    _first_entry($self->[0]);
}

sub key {
    my $self = shift;
    _key($self->[0]);
}

sub data {
    my $self = shift;
    _data   ($self->[0]);
}

sub next_entry {
    my $self = shift;
    _next_entry($self->[0]);
}

sub valid_entry {
    my $self = shift;
    _valid_entry($self->[0]);
}

sub seek {
    my $self = shift;
    _seek($self->[0], @_);
}

sub delete_entry {
    my $self = shift;
    _delete_entry($self->[0]);
}

sub prev_entry {
    my $self = shift;
    _prev_entry($self->[0]);
}

sub last_entry {
    my $self = shift;
    _last_entry($self->[0]);
}

sub DESTROY {
    my $self = shift;
    _release($self->[0], $self->[1]);
}

1;
__END__

=encoding utf-8

=for stopwords UnQLite serverless NoSQL CouchDB BerkeleyDB LevelDB stringified

=head1 NAME

UnQLite - Perl bindings for UnQLite

=head1 SYNOPSIS

    use UnQLite;

    my $db = UnQLite->open('foo.db');
    $db->kv_store('foo', 'bar');
    say $db->kv_fetch('foo'); # => bar
    $db->kv_delete('foo');
    undef $db; # close database

=head1 DESCRIPTION

UnQLite is a in-process software library which implements a self-contained, serverless, zero-configuration, transactional NoSQL database engine. UnQLite is a document store database similar to MongoDB, Redis, CouchDB etc. as well a standard Key/Value store similar to BerkeleyDB, LevelDB, etc.  

This module is Perl5 binding for UnQLite.

If you want to know more information about UnQLite, see L<http://unqlite.org/>.

This version of UnQLite.pm does not provides document store feature. Patches welcome.

B<You can use UnQLite.pm as DBM>.

=head1 METHODS

=over 4

=item C<< my $db = UnQLite->open('foo.db'[, $mode]); >>

Open the database.

=item C<< $db->kv_store($key, $value); >>

Store the entry to database.

=item C<< $db->kv_fetch($key); >>

Fetch data from database.

=item C<< $db->kv_delete($key); >>

Delte C< $key > from database.

=item C<< $db->rc(); >>

Return code from UnQLite. It may updates after any UnQLite API call.

=item C<< $db->errstr() >>

This API returns stringified version of C<< $db->rc() >>. It's not human readable but it's better than magic number.

=item C<< my $cursor = $db->cursor_init() >>

Create new cursor object.

=back

=head1 UnQLite::Cursor

UnQLite supports cursor for iterating entries.

Here is example code:

    my $cursor = $db->cursor_init();
    my @ret;
    for ($cursor->first_entry; $cursor->valid_entry; $cursor->next_entry) {
        push @ret, $cursor->key(), $cursor->data()
    }

=head2 METHODS

=over 4

=item C<< $cursor->first_entry() >>

Seek cursor to first entry.

Return true if succeeded, false otherwise.

=item C<< $cursor->last_entry() >>

Seek cursor to last entry.

Return true if succeeded, false otherwise.

=item C<< $cursor->valid_entry() >>

This will return 1 when valid. 0 otherwise

=item C<< $cursor->key() >>

Get current entry's key.

=item C<< $cursor->data() >>

Get current entry's data.

=item C<< $cursor->next_entry() >>

Seek cursor to next entry.

=item C<< $cursor->prev_entry() >>

Seek cursor to previous entry.

Return true if succeeded, false otherwise.

=item C<< $cursor->seek($key, $opt=UNQLITE_CURSOR_MATCH_EXACT) >>

Seek cursor to C< $key >.

You can specify the option as C< $opt >. Please see L<http://unqlite.org/c_api/unqlite_kv_cursor.html> for more details.

Return true if succeeded, false otherwise.

=item C<< $cursor->delete_entry() >>

Delete the database entry pointed by the cursor.

Return true if succeeded, false otherwise.

=back

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

