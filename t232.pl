#!/usr/bin/perl

use Device::SerialPort;

my $timeout = 10;
my $port = Device::SerialPort->new("/dev/ttyUSB0")||die "Couldn't open port $!\n";

$port->user_msg(ON);
$port->baudrate(4800);
$port->databits(8);
$port->parity("none");
$port->stopbits(1);
$port->handshake("none");
$port->read_char_time(0);
$port->read_const_time(1000);
die "Couldn't write port settings: $!" unless $port->write_settings;

my $code = "\x24\x10\x05\x01\x01\x00\x32\x01\x55";
my $count_out = $port->write($code);

while ($timeout > 0){
  # Read enough characters from port to guarantee a complete reading
  my ($count,$saw) = $port->read(12);
  if($count > 0){
  # Uncomment to print hex values of data from port
  #  my $output="";
  #  @data = unpack('C*',$saw);
  #  foreach my $c (@data){
  #    $output .=  sprintf("%lx",$c) . " " ;
  #  }
  #  print "$output\t";
  if ($saw=~m/\x24\xfe\x02(\C\C)\x55/){
    $raw =  unpack('n*',$1);
    $raw -= 1<<16 if $raw & 1 << 15;
    $temp = $raw * 0.007812;
    print "$temp\n";
    last;
    }
  }
  else{
    $timeout--;
  }
}
$code = "\x24\x11\x00\x55";
$port->write($code);
