# NAME

UnQLite - Perl bindings for UnQLite

# SYNOPSIS

    use UnQLite;

    my $db = UnQLite->open('foo.db', UnQLite::OPEN_READWRITE|UnQLite::OPEN_CREATE);
    $db->kv_store('foo', 'bar');
    say $db->kv_fetch('foo'); # => bar
    $db->kv_delete('foo');
    undef $db; # close database

    # tie interface
    tie my %hash, 'UnQLite', 'foo.db', UnQLite::OPEN_READWRITE;
    $hash{foo} = 'bar';
    say $hash{foo}; # => bar

# DESCRIPTION

UnQLite is a in-process software library which implements a self-contained, serverless, zero-configuration, transactional NoSQL database engine. UnQLite is a document store database similar to MongoDB, Redis, CouchDB etc. as well a standard Key/Value store similar to BerkeleyDB, LevelDB, etc.  

This module is Perl5 binding for UnQLite.

If you want to know more information about UnQLite, see [http://unqlite.org/](http://unqlite.org/).

This version of UnQLite.pm does not provides document store feature. Patches welcome.

__You can use UnQLite.pm as DBM__.

# METHODS

- `my $db = UnQLite->open('foo.db'[, $mode]);`

    Open the database.

    Modes:

        UnQLite::OPEN_CREATE      (Default)
        UnQLite::OPEN_READONLY
        UnQLite::OPEN_READWRITE
        UnQLite::OPEN_EXCLUSIVE
        UnQLite::OPEN_TEMP_DB
        UnQLite::OPEN_OMIT_JOURNALING
        UnQLite::OPEN_IN_MEMORY
        UnQLite::OPEN_MMAP

- `$db->kv_store($key, $value);`

    Store the entry to database.

- `$db->kv_fetch($key);`

    Fetch data from database.

- `$db->kv_delete($key);`

    Delte ` $key ` from database.

- `$db->rc();`

    Return code from UnQLite. It may updates after any UnQLite API call.

- `$db->errstr()`

    This API returns stringified version of `$db->rc()`. It's not human readable but it's better than magic number.

- `my $cursor = $db->cursor_init()`

    Create new cursor object.

# UnQLite::Cursor

UnQLite supports cursor for iterating entries.

Here is example code:

    my $cursor = $db->cursor_init();
    my @ret;
    for ($cursor->first_entry; $cursor->valid_entry; $cursor->next_entry) {
        push @ret, $cursor->key(), $cursor->data()
    }

## METHODS

- `$cursor->first_entry()`

    Seek cursor to first entry.

    Return true if succeeded, false otherwise.

- `$cursor->last_entry()`

    Seek cursor to last entry.

    Return true if succeeded, false otherwise.

- `$cursor->valid_entry()`

    This will return 1 when valid. 0 otherwise

- `$cursor->key()`

    Get current entry's key.

- `$cursor->data()`

    Get current entry's data.

- `$cursor->next_entry()`

    Seek cursor to next entry.

- `$cursor->prev_entry()`

    Seek cursor to previous entry.

    Return true if succeeded, false otherwise.

- `$cursor->seek($key, $opt=UnQLite::CURSOR_MATCH_EXACT)`

    Seek cursor to ` $key `.

    You can specify the option as ` $opt `. Please see [http://unqlite.org/c\_api/unqlite\_kv\_cursor.html](http://unqlite.org/c\_api/unqlite\_kv\_cursor.html) for more details.

    Return true if succeeded, false otherwise.

- `$cursor->delete_entry()`

    Delete the database entry pointed by the cursor.

    Return true if succeeded, false otherwise.

# LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokuhirom <tokuhirom@gmail.com>
