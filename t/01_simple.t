use strict;
use Test::More;

use File::Temp qw(tempdir);
use Unqlite;

my $tmp = tempdir( CLEANUP => 1 );

my $db = Unqlite->open("$tmp/foo.db");
isa_ok($db, 'Unqlite');

ok($db->kv_store("foo", "bar"));
is($db->kv_fetch('foo'), 'bar');
ok($db->kv_delete('foo'));
is($db->kv_fetch('foo'), undef);

done_testing;

