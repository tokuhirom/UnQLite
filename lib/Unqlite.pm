package Unqlite;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";
our $rc = 0;

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

sub rc { $Unqlite::rc }

sub errstr {
    my $self = shift;
    if ($rc==Unqlite::UNQLITE_OK()) { return "UNQLITE_OK" }
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

1;
__END__

=encoding utf-8

=head1 NAME

Unqlite - Perl bindings for Unqlite

=head1 SYNOPSIS

    use Unqlite;

    my $db = Unqlite->open('foo.db');
    $db->kv_store('foo', 'bar');
    say $db->kv_fetch('foo'); # => bar
    $db->kv_delete('foo');
    undef $db; # close database

=head1 DESCRIPTION

UnQLite is a in-process software library which implements a self-contained, serverless, zero-configuration, transactional NoSQL database engine. UnQLite is a document store database similar to MongoDB, Redis, CouchDB etc. as well a standard Key/Value store similar to BerkeleyDB, LevelDB, etc.  

This module is Perl5 binding for Unqlite.

If you want to know more information about Unqlite, see L<http://unqlite.org/>.

Current version of Unqlite.pm supports only some C<kv_*> methods. Patches welcome.

=head1 METHODS

=over 4

=item C<< my $db = Unqlite->open('foo.db'[, $mode]); >>

Open the database.

=item C<< $db->kv_store($key, $value); >>

Store the entry to database.

=item C<< $db->kv_fetch($key); >>

Fetch data from database.

=item C<< $db->kv_delete($key); >>

Delte C< $key > from database.

=item C<< $db->rc(); >>

Return code from unqlite. It may updates after any Unqlite API call.

=item C<< $db->errstr() >>

This API returns stringified version of C<< $db->rc() >>. It's not human readable but it's better than magic number.

=back

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

