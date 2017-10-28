requires 'perl', '5.010';

requires 'Mojolicious';

on 'test' => sub {
    requires 'File::Spec';
    requires 'File::Temp';
    requires 'Test::More', '0.96';
};
