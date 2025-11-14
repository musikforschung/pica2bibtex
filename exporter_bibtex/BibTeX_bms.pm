package Catmandu::Exporter::BibTeX;

# extra tags added 07/25 by René Wallor - Staatliches Institut für Musikforschung (version 0.23)

our $VERSION = '0.21';

use namespace::clean;
use Catmandu::Sane;
use Clone qw(clone);
use Moo;

with 'Catmandu::Exporter';

my $TAGS = [
    qw(
        abstract
		abstract_I
		abstract_II
        abstractor
		abstractor_I
		abstractor_II
		abstract_language
		abstract_I_language
		abstract_II_language
        address
		articleno
        author
        author_afterword 
        author_collaborator
        author_commentator
        author_compiled
        author_foreword
        author_illustrator
        author_introduction
        author_supervisor
        author_translator
        booktitle
        chapter
        country
        crossref
        day
        edition
        editor
        eprint
        eventdate
        eventtitle
        honoured
        howpublished
        institution
        isbn
        issn
        journal
        keywords
        language
        language_original
        location
        month
        note
        number
		number_I
		number_II
		number_III
        organization
        pages
        publisher
        revieweditem
        school
        series
		series_I
		series_II
		series_III
        title
        type
        url
        doi
        volume
		volume_I
		volume_II
		volume_III
        year
        )
];

my $JOIN = {author => ' and ', author_afterword => ' and ', author_collaborator => ' and ', author_commentator => ' and ', author_compiled => ' and ', author_foreword => ' and ', author_illustrator => ' and ', author_introduction => ' and ', author_supervisor => ' and ', author_translator => ' and ', country => ',', editor => ' and ', honoured => ' and ', language => ',', institution => ' and ', keywords => ',', publisher => ' and ',};

sub add {
    my ($self, $orig_data) = @_;

    my $data = clone($orig_data);

    my $fh = $self->fh;

    my $type    = $data->{type}     || $data->{_type} || 'misc';
    my $citekey = $data->{_citekey} || $data->{_id}   || $self->count + 1;

    for my $tag (keys %$JOIN) {
        my $val = $data->{$tag};
        if ($val && ref($val) eq 'ARRAY') {
            $data->{$tag} = join $JOIN->{$tag}, @$val;
        }
    }

    print $fh "\@$type\{$citekey,\n";

    for my $tag (@$TAGS) {
        if (my $val = $data->{$tag}) {
            printf $fh "  %-12s = {%s},\n", $tag, $val;
        }
    }

    print $fh "}\n\n";
}

=head1 NAME

Catmandu::Exporter::BibTeX - a BibTeX exporter

=head1 SYNOPSIS

    use Catmandu::Exporter::BibTeX;

    my $exporter = Catmandu::Exporter::BibTeX->new(fix => 'myfix.txt');

    $exporter->add_many($arrayref);
    $exporter->add_many($iterator);
    $exporter->add_many(sub { });

    $exporter->add($hashref);

    $exporter->add({
     type    => 'book',
     _citekey => '389-ajk0-1',
     title    => 'the Zen of {CSS} design',
     author   => ['Dave Shea','Molley E. Holzschlag'],
     isbn     => '0-321-30347-4'
    });

    printf "exported %d objects\n" , $exporter->count;

=head1 DESCRIPTION

The BibTeX L<Catmandu::Exporter> requires as input a Perl hash (or a fix)
containing BibTeX fields and values as a string or array reference.

=head1 SUPPORTED FIELDS

Two special fields can be set in the Perl hash:

=over

=item C<type> or C<_type>

to describe the document type (article, book, ...). Set to 'misc' by default.

=item C<_citekey> or C<_id>

to describt the citation key. The next counter value (starting from 1) is used
by default.

=back

The following BibTeX fields are supported. All other fields are ignored.

    abstract
    address
    author
    booktitle
    chapter
    day
    edition
    editor
    eprint
    howpublished
    institution
    isbn
    issn
    journal
    keywords
    language
    location
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    url
    doi
    volume
    year

=head1 SEE ALSO

Use L<Catmandu::Fix::expand_date> to expand a date field with year, month, and day
into the corresponding BibTeX fields.

=cut

1;