with Ada.Text_IO;
with Ada.IO_Exceptions;
with GNAT.Sockets;
with Ada.Characters.Latin_1;
with Ada.Streams;

procedure Main is
   use GNAT.Sockets;
   use Ada.Text_IO;


   procedure Write_Finnish (S : Socket_Type; C : Stream_Access) is
      use Ada.Characters.Latin_1;
      --Message : String := String'Input (C);
      Response : String := "HTTP/1.1 200 OK " & CR&LF &
"Content-Type: text/html; charset=UTF-8" & CR&LF&CR&LF &
"<!DOCTYPE html><html><head><title>Bye-bye baby bye-bye</title>" &
"<style>body { background-color: #111 }" &
"h1 { font-size:4cm; text-align: center; color: black;" &
" text-shadow: 0 0 2mm red}</style></head>" &
        "<body><h1>Goodbye, world!</h1></body></html>" & CR&LF;
   begin
      String'Write (C, Response);
      Shutdown_Socket (S, Shut_Write);
   end;

   Receiver   : Socket_Type;
   Connection : Socket_Type;
   Client     : Sock_Addr_Type;
   Channel    : Stream_Access;

begin
   Initialize;

   Create_Socket (Receiver);
   Set_Socket_Option (Receiver, Socket_Level, (Name => Reuse_Address, Enabled => True));
   Bind_Socket (Receiver, (Family => Family_Inet, Addr => Any_Inet_Addr, Port => 80));
   Listen_Socket (Receiver);

   loop
      Accept_Socket (Receiver, Connection, Client);
      Put_Line ("Client connected from " & Image (Client));
      Channel := Stream (Connection);
      Write_Finnish (Connection, Channel);
      Close_Socket (Connection);
   end loop;

   --Finalize;
end;
