use strict;
use warnings;
use utf8;
use FindBin;
use lib 't/lib';
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
my $app = MT->instance;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $blog = $app->model('blog')->load( $blog_id ) or die;
$blog->date_language('ja');
$blog->save or die;

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

===
--- SKIP
--- template
<mt:Date ts="20141010101010" format="%%Ey" />
--- expected
%Ey

===
--- template
<mt:Date ts="20141010101010" format="%EY" />
--- expected
平成26年

===
--- template
<mt:Date ts="20191010101010" format="%EY" />
--- expected
令和元年

===
--- template
<mt:Date ts="20201010101010" format="%EY" />
--- expected
令和2年

===
--- template
<mt:Date ts="20200202101010" format="%EX" />
--- expected
10時10分10秒

===
--- template
<mt:Date ts="20200202101010" format="%Ex" />
--- expected
令和2年02月02日

===
--- template
<mt:Date ts="20141010101010" format="%Ec" />
--- expected
平成26年10月10日 10時10分10秒

===
--- SKIP
--- template
<mt:Date ts="20141010101010" format="%Ec" language="en"/>
--- expected
Oct 10, 2014 10:10:10 AM

===
--- template
<mt:Date ts="20141010101010" format="%EY" language="en"/>
--- expected
2014

