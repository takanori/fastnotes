package FastNotes::Controller::Auths;
use strict;
use warnings;
use v5.10;

use base 'Mojolicious::Controller';

sub create {
    my ($self) = @_;

    my $login    = $self->param('login');
    my $password = $self->param('password');
					
    # my $user = FastNotes::Model::User->select({login => $login, password=>$password})->hash();
	my $row = $self->app->db->single('users',
		{
			login => $login,
			password => $password,
		},
		{ }
	);

    if ( $row  && $row->user_id ) {
        $self->session(
            user_id => $row->user_id,
            login   => $row->login
        )->redirect_to('users_show');
    }
    else {
        $self->flash( error => 'Wrong password or user does not exist!' )->redirect_to('auths_create_form');
    }
}

sub delete {
    shift->session( user_id => '', login => '' )->redirect_to('auths_create_form');
}

sub check {
    shift->session('user_id') ? 1 : 0;
}

1;

