package VMS::Queue;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw();

@EXPORT_OK = qw(&queue_list &stop_queue &pause_queue &reset_queue
                &start_queue &delete_queue &create_queue &modify_queue &submit 
                &queue_info &queue_properties &queue_bitmap_decode 
                &entry_list &delete_entry &hold_entry &release_entry 
                &modify_entry &entry_properties &entry_bitmap_decode
                &entry_info &file_list &file_properties &file_bitmap_decode
                &form_list  &delete_form &create_form &modify_form  
                &form_info &form_properties &form_bitmap_decode
                &characteristics_list &create_characteristics
                &delete_characteristics &modify_characteristics
                &characteristic_info &characteristic_properties
                &characteristic_bitmap_decode &manager_list
                &stop_manager &start_manager &create_manager &modify_manager
                &delete_manager &manager_info &manager_properties
                &manager_bitmap_decode);

$VERSION = '0.57';

bootstrap VMS::Queue $VERSION;

#sub new {
#  my($pkg,$pid) = @_;
#  my $self = { __PID => $pid || $$ };
#  bless $self, $pkg; 
#}

#sub one_info { get_one_proc_info_item($_[0]->{__PID}, $_[1]); }
#sub all_info { get_all_proc_info_items($_[0]->{__PID}) }

#sub TIEHASH { my $obj = new VMS::ProcInfo @_; $obj; }
#sub FETCH   { $_[0]->one_info($_[1]); }
#sub EXISTS  { grep(/$_[1]/, proc_info_names()) }

# Can't STORE, DELETE, or CLEAR--this is readonly. We'll Do The Right Thing
# later, when I know what it is...

#sub FIRSTKEY {
#  $_[0]->{__PROC_INFO_ITERLIST} = [ proc_info_names() ];
#  $_[0]->one_info(shift @{$_[0]->{__PROC_INFO_ITERLIST}});
#}
#sub NEXTKEY { $_[0]->one_info(shift @{$_[0]->{__PROC_INFO_ITERLIST}}); }

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

VMS::Queue - Perl extension to manage queues, entries, and forms, and retrieve
queue, entry, and form information.

=head1 SYNOPSIS

  use VMS::Queue;

Queue routines

  @ListOfQueues = queue_list([\%Queue_Properties]);
  $Status = stop_queue($Queue_Name);
  $Status = pause_queue($Queue_Name);
  $Status = reset_queue($QueueName);
  $Status = start_queue($Queue_Name);
  $Status = delete_queue($Queue_Name);
  $Status = create_queue(\%Queue_Properties);
  $Status = modify_queue(\%Queue_Properties);
  $EntryNum = submit(\%Entry_Properties, \%Entry_File_Properties[,...]] );
  \%QueueProperties = queue_info($Queue_Name);
  \%ValidQueueProperties = queue_properties();
  \%DecodedBitmap = queue_bitmap_decode($AttribName, $Bitmap);

Entry routines

  @ListOfEntries = entry_list([\%Entry_Properties[, \%Queue_Properties]]);
  $Status = delete_entry($Entry_Number);
  $Status = hold_entry($Entry_Number);
  $Status = release_entry($Entry_Number);
  $Status = modify_entry(\%Entry_Properties);
  \%EntryProperties = entry_info($Entry_Number);
  \%ValidEntryProperties = entry_properties();
  \%DecodedBitmap = entry_bitmap_decode($AttribName, $Bitmap);

File routines
  @ListOfFileHashrefs = file_list($Entry_Number);
  \%ValidFileProperties = file_properties();
  \%DecodedBitmap = file_bitmap_decode($AttribName, $Bitmap)

Form Routines

  @ListOfForms = form_list([\%Form_Properties]);
  $Status = create_form(%Form_Properties);
  $Status = delete_form($Form_Name);
  \%Form_Properties = form_info($Form_Number);
  \%ValidFormProperties = form_properties();
  \%DecodedBitmap = form_bitmap_decode($AttribName, $Bitmap);

Characteristic Routines

  @ListOfCharacteristics = characteristic_list([\%Characteristic_Properties]);
  $Status = create_characteristic(%Characteristic_Properties);
  $Status = delete_characteristic($Characteristic_Name);
  \%Characteristic_Properties = characteristic_info($Characteristic_Number);
  \%ValidCharacteristicProperties = characteristic_properties();
  \%DecodedBitmap = characteristic_bitmap_decode($AttribName, $Bitmap);

Queue Manager Routines
  @ListOfQueueManagers = manager_list([\%Manager_Properties]);
  $Status = stop_manager($Manager_Name);
  $Status = start_manager($Manager_Name);
  $Status = delete_manager(%Manager_Properties);
  \%Manager_Properties = manager_info($Manager_Name);
  \%ValidManagerProperties = manager_properties();
  \%DecodedBitmap = manager_bitmap_decode($AttribName, $Bitmap);

=head1 DESCRIPTION

The VMS::Queue module lets a perl script (running as a user with
appropriate privileges) manage queues, queue entries, forms,
characteristics, and queue managers.

=head2 Queue functions

The queue functions create, delete, manipulate, or list queues. Most
functions take either a queue name or a queue property hash. (With the
exception of submit, which takes an entry property hash) The valid hash
keys for each of the hashes is detailed in the L<"Property hashes">
section.

=item queue_list()

The C<queue_list> function takes an optional C<Queue_Properties> hash, and
returns a list of all the queues that match the properties in the hash. If
no property hash is passed, then a list of all queues is returned.

=item stop_queue()

The C<stop_queue> function stops the passed queue, essentially doing a
STOP/QUEUE from DCL. If the optional second parameter is TRUE, then a
STOP/QUEUE/NEXT is done instead.

=item start_queue()

The C<start_queue> function starts the passed queue.

=item delete_queue()

The C<delete_queue> function deletes the named queue.

=item create_queue()

The C<create_queue> function creates a new queue with the passed
properties.

=item modify_queue()

The C<modify_queue> function modifies the queue referenced in the passed
properties hash. Any property passed in the hash will be applied to the
queue referenced in the hash if at all possible. (Some things can't be
modified for existing queues. In that case, you'll have to delete and
recreate the queue)

=item submit()

C<submit> takes a reference to an C<Entry_Properties> hash, and a reference
to one or more C<Entry_File_Properties> hashes. The files are submitted as
a single entry to the queue manager. It returns the entry number if
sucessful, or undef if not.

=item queue_info()

The C<queue_info> function returns a reference to a C<Queue_Property> hash,
with the properties for the queue filled in.

=item queue_properties()

This funnction returns a reference to a hash whose keys are the valid keys
for a C<queue_property> hash. The values for the keys are currently
undefined, though they might mean something in a future release.

=item queue_bitmap_decode()

Takes an attribute and an integer, and returns a reference to a hash. The
properties are in the keys, while the values are C<INPUT>, C<OUTPUT>, or
C<INPUT,OUTPUT>. C<INPUT> properties may be specified to a call that takes
a queue_propery hash, while C<OUTPUT> properties may be returned by a call
that returns a queue_property hash.

=head2 Entry functions

The entry functions provide a way to manipulate queue entries. 

=item entry_list()

This function provides a list of all the entries that match the optional
C<entry_properties> hash. If no hash is passed, all entries in all queues
are returned.

=item delete_entry()

Deletes the entry identified by the passed entry number.

=item hold_entry()

Marks the passed entry as on hold.

=item release_entry()

Releases the passed entry.

=item modify_entry()

Modifies the entry, as identified in the entry_properties hash, with the
new properties in the hash. Not all properties for a queue entry are
modifiable, so this might throw an error.

=item entry_info()

Returns an entry_property hash with the properties for the passed entry.

=item entry_properties()

Returns the valid properties that can be in an entry_property hash. The
properties are in the keys, while the values is a hashref with these four
elements: C<INPUT_INFO>, C<OUTPUT_INFO>, C<INPUT_ACTION>, and
C<OUTPUT_ACTION>. Each of these four hash entries will be set to true or
false depending on whether the particular property can be specified as
input or output for an action or info routine. (Action routines do
something--create or delete a queue for example--while info routines return
information on a queue or entry)

=item entry_bitmap_decode()

Takes an attribute and an integer, and returns a reference to a hash. The
hash decodes the bitmap--each key refers to a bit in the bitmap, with the
value set to true or false, depending on the value of the bit in the
integer.

=head2 File functiond

The file functions deal with files within queue entries.

=item file_list()

This function returns a list of hashrefs. Each hashref corresponds to one
file for the entry. (We do things this way since there's no easy way to
refer to a particular file within an entry, so the xxx_list/xxx_info pair
that the other groups use has no easy way to implement.)

=item file_properties()

This function returns a list of all the valid properties that can be
returned for a file.

=item file_bitmap_decode

Takes an attribute and an integer, and returns a reference to a hash. The
hash decodes the bitmap--each key refers to a bit in the bitmap, with the
value set to true or false, depending on the value of the bit in the
integer.

=head2 Form functions

The form functions manipulate the form information kept by the queue manager.

=item form_list()

This function returns a list of all forms that match the optional form
properties hash. If no hash is passed, then all forms are returned.

=item create_form()

This function creates a form with the properties specified in the
form_properties hash.

=item delete_form()

This function deletes the form specified.

=item form_info()

Returns an form_properties hashref with all the properties for the
specified form.

=head2 Characteristic functions

=item characteristic_list

=item create_characteristic

=item delete_characteristic

=item characteristic_info

=item characteristic_properties

=item characteristic_bitmap_decode

=head2 Manager functions

=item manager_list

=item stop_manager

=item start_manager

=item delete_manager

=item manager_info

=item manager_properties

=item manager_bitmap_decode

=head2 Property hashes

There are several different property hashes that are passed around, either
directly or by reference. The keys are always the symbol names as found in
the documentation for the system calls $GETQUI and $SNDJBC, minus any
prefix (i.e. $QUI$_ACCOUNT_NAME is ACCOUNT_NAME, and QUI$V_SEARCH_BATCH is
SEARCH_BATCH)

=head1 BUGS

May leak memory. May not, though.

=head1 LIMITATIONS

The documentation isn't finished. (Hey, it's 0.12)

There's a very limited amount of error checking at the moment. If you try
to modify something with a parameter that's for creation only (or vice
versa), the syscall will fail and the function will C<croak()>. 

The test suite's of limited utility.(Okay, it doesn't test anything really)

=head1 AUTHOR

Dan Sugalski <dan@sidhe.org>

=head1 SEE ALSO

perl(1), VMS System Services Reference Guide, SNDJBC and GETQUI entries.

=cut
                                                                                                                                                                                                                                                                                                                                                                                   Ä*          †y                         Ä    ï¸               Ä   4Ø ó…          ﬂ          zs          NB               Ä   óØ  y^ Â      ≤Æ                    ï               Ä   KÙ A¸          o               Ä   ‡  Cé          ^                Ä   j4 ƒQ U ˚T               Ä   √  ’  0˘           Ä   ÿO ﬂ ≈¸           Ä   ı  Üù û      –\           Nâ          ˛≤                    £               Ä   - . ân      0          ]               Ä   (} ùÅ ≥K           Ä   ù0 √( Æ)           Ä   1 «z          Ω£               Ä   %â	  
               Ä   xn 8o q      Ä±                Ä   ù ØÙ          ZÍ          ΩN               Ä   R “	 Õ	           Ä   6 GÀ Û ÷ õ'           Ä   c∂ ﬁ∂          ck           e          —”          ‡               Ä   ı  ¥˘                Ä   j:  £d ‘           Ä   ìg Ùg               Ä   Ä[ ][          ¯?               Ä   ‡Ì  Î◊               Ä   W ÕZ     	          Ä   ‘  œ  n˝ ∑˛ ;¥
 Ô¥
               Ä   ı  ¥˘  W ÕZ ck      I—               Ä   9< 3< ú@       ã               Ä   – ‰t                    Õè                Ä   XÁ  Ó                Ä   ä– N          #v     #           Ä    ñ•  ’  ˚Œ  ∞ HO ßÊ §} Oó .¸ ç ¢° Ô¢ ≥Z Ó∏ —‹ ˆ" [> ¬∂ —« Iì  è 6 œY X £õ /§ x∑ äm	 `+
 £+
 –+
               Ä   ~C 9Ã ﬁi b               Ä   ”Á  √ã          π          q_          \^          ‘÷               Ä   	 mx               Ä   w∞ ó'	 $*	      H%               Ä   Ï∞ 3≥               Ä   ‡  .‚  yÂ       ¥\               Ä     Wm          l±          v∏               Ä   q∆            ˜w               Ä   õ ˇ´          Ü–          ≠t          Ó           ı®               Ä   $ ç          ËL     
          Ä   m ˚2 7 8 7 o‘ Î~
      DŒ
          ∫º               Ä   AP qU               Ä   ,0 ˜Z               Ä   ß  Íµ ¢∂ û∂          4               Ä   " X          ân               Ä   f Ëm µs           Ä   LM Hò
               Ä   [ h x  ı      ≈m           vÜ          ^ƒ               Ä   œ∆  Ü»  o      ı“          7          ï          ß           fk               Ä   _D I Ã˜ ˚          +          9ê               Ä   €  ÁL               Ä   Dó µv ¸]	      €C           ¬          l               Ä   7Ì ¬#
          A               Ä   ; ·: ”> ‹>               Ä   %@ ‹C –C %    "      Ä"   G©  Ñ¨  ’  ÈÃ  à∞ eæ SF r[ ZÙ å? òú «ù kô K¡ ‡ È òø Q pZ ZZ πS `~ ‰ﬁ ¿ ., Ç =Ñ Ì ¿Ì e¯ h º b Ò=
          ±^               Ä   ¨! œK ÕM      =          Ë-          SZ          -_               ê      ¿% »% b(               ò         +) ﬁã å îè & & í#      :          û	                Ä   m€ Ç› Ö› ªE ∫J ªJ 0— ;— ”” Of Eh ZŸ kŸ æp 1v ;v          94               Ä   ë¶  í¶  K≠  Q≠  ^≠  d≠  %≤  )≤  x∞ k≤ ©¯ Oˇ Qˇ           ò         +) ﬁã å îè & & í#      wR	          Jq                    ≈ù          ¡˚               Ä   ê "          Î‰                Ä   åF  e< Ñ	 	          Ä   Z > üa æú ÷ù ≈ô          çe          ª∏          DΩ           v‚                Ä   ¸Î ¬ ^¬
          Ä      —~ ;∏           Ä   >\ ü          >\          Ø·               Ä   “n Er ﬁÖ      í#               Ä   DZ 
               Ä   8ä N          &ò               Ä   ∞! D~               Ä   CJ 'Ÿ               Ä   ‘& :, 2 º                Ä   °ñ l	               Ä   ^ï Eb Nh 4Ü               Ä   ≤q   ?€ ˝‡ ﬁ#	 ñ=
 W>
 ¡B
 ¬o
 p
 ⁄v
          √               Ä   àÂ dÍ ≠U iZ               Ä   Œ£ ¸I          ßs               Ä   | ~ ÷Ä •∫ Pæ 