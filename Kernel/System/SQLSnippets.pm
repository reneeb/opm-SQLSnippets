# --
# Copyright (C) 2024 - 2024 Perl-Services.de, https://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SQLSnippets;

use strict;
use warnings;

use List::Util qw(first);

our @ObjectDependencies = qw(
    Kernel::System::Log
    Kernel::System::DB
    Kernel::Config
);

=head1 NAME

Kernel::System::SQLSnippets

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item SnippetAdd()

    my $ID = $SnippetObject->SnippetAdd(
        Name => "Name",
        SQL  => "Sample text",
    );

=cut

sub SnippetAdd {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');

    # check needed stuff
    for my $Needed ( qw(SnippetName SQL) ) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # insert new tag
    return if !$DBObject->Do(
        SQL => 'INSERT INTO ps_sqlsnippets '
            . ' (name, snippet) '
            . ' VALUES (?, ?) ',
        Bind => [
            \$Param{SnippetName},
            \$Param{SQL},
        ],
    );

    # get new tag id
    return if !$DBObject->Prepare(
        SQL   => 'SELECT MAX(id) FROM ps_sqlsnippets WHERE name = ?',
        Bind  => [ 
            \$Param{SnippetName},
        ],
        Limit => 1,
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
    return if !$ID;

    # log notice
    $LogObject->Log(
        Priority => 'notice',
        Message  => "Snippet '$ID' created successfully!",
    );

    return $ID;
}


=item SnippetUpdate()

update

    my $Success = $SnippetObject->SnippetUpdate(
        SnippetID   => 123,
        SnippetName => 'A Name',
        SQL         => "Sample text",
    );

=cut

sub SnippetUpdate {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');

    # check needed stuff
    for my $Needed (qw(SnippetID SQL SnippetName) ) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # update tag
    return if !$DBObject->Do(
        SQL => 'UPDATE ps_sqlsnippets SET '
            . ' snippet = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{SQL},
            \$Param{SnippetID},
        ],
    );

    return 1;
}

=item SnippetDelete()

deletes an entry. Returns 1 if it was successful, undef otherwise.

    my $Success = $SnippetObject->SnippetDelete(
        ID => 123,
    );

=cut

sub SnippetDelete {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');

    # check needed stuff
    if ( !$Param{ID} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need ID!',
        );
        return;
    }

    return $DBObject->Do(
        SQL  => 'DELETE FROM ps_sqlsnippets WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
}


=item SnippetList()

returns a hash of all entries

    my %Snippet = $SnippetObject->SnippetList();

the result looks like

    %Snippet = (
        1 => {
            SnippetName => 'anything',
            SQL         => 'an object',
        },
    );

=cut

sub SnippetList {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL   = "SELECT id, name, snippet FROM ps_sqlsnippets";

    # sql
    return if !$DBObject->Prepare(
        SQL  => $SQL,
    );

    my %Snippet;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $Snippet{ $Data[0] } = {
            SQL         => $Data[2],
            SnippetName => $Data[1],
        };
    }

    return %Snippet;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

