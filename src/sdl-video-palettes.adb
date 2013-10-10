with Ada.Finalization; use Ada.Finalization;

package body SDL.Video.Palettes is
   --  function Element_Value (Container : in Palette_array; Pos : in Palette_Cursor) return Colour is
   --  begin
   --     return Pos.Current.all;
   --  end Element_Value;

   --  function Has_Element (Pos : in Palette_Cursor) return Boolean is
   --  begin
   --     --  if Pos.Index < Positive (Pos.Container.Internal.Total) then
   --     if Pos.Index < Pos.Total then
   --        return True;
   --     end if;

   --     return False;
   --  end Has_Element;

   --  function Iterate (Container : not null access Palette_Array) return Palette_Iterators'Class is
   --  begin
   --     return It : constant Palette_Iterators := Palette_Iterators'(Container => Palette_Access (Container)) do
   --        null;
   --     end return;
   --  end Iterate;

   --  function First (Object : in Palette_Iterators) return Palette_Cursor is
   --  begin
   --     return Palette_Cursor'
   --       (--  Container => Object.Internal,
   --        Index     => Positive'First,
   --        Total     => Positive (Object.Container.Internal.Total),
   --        Current   => Object.Container.Internal.Colours);
   --  end First;

   --  function Next (Object : in Palette_Iterators; Position : in Palette_Cursor) return Palette_Cursor is
   --     Curr : Colour_Array_Pointer.Pointer := Position.Current;
   --  begin
   --     Colour_Array_Pointer.Increment (Curr);

   --     return Palette_Cursor'
   --       (--  Container => Object.Internal,
   --        Index     => Position.Index + 1,
   --        Total     => Position.Total,
   --        Current   => Curr);
   --  end Next;

   type Iterator (Container : access constant Palette'Class) is new Limited_Controlled and
        Palette_Iterator_Interfaces.Forward_Iterator with
   record
      Index : Natural;
   end record;

   overriding
   function First (Object : Iterator) return Cursor;

   overriding
   function Next (Object : Iterator; Position : Cursor) return Cursor;

   function Element (Position : in Cursor) return Colour is
   begin
      --  return Position.Container.Data.Colours (Position.Index);
      return Colour_Array_Pointer.Value (Position.Current) (0);
   end Element;

   function Has_Element (Position : Cursor) return Boolean is
   begin
      if Position.Index <= Natural (Position.Container.Data.Total) then
         return True;
      end if;

      return False;
   end Has_Element;

   function Constant_Reference
     (Container : aliased Palette;
      Position  : Cursor) return Colour is
   begin
      --Put_Line ("Constant_Reference" & Natural'Image (Position.Index));

      --  return Position.Container.Data.Colours (Position.Index);
      return Colour_Array_Pointer.Value (Position.Current) (0);
   end Constant_Reference;

   function Iterate (Container : Palette) return
     Palette_Iterator_Interfaces.Forward_Iterator'Class is
   begin
--      Put_Line ("Iterate");

      return It : constant Iterator :=
        (Limited_Controlled with
           Container => Container'Access, Index => Natural'First + 1)
      do
        --Put_Line ("  index = " & Natural'Image(It.Index));
        null;
      end return;
   end Iterate;

   function First (Object : Iterator) return Cursor is
   begin
      --Put_Line ("First -> Index = " & Natural'Image (Object.Index));

      return Cursor'(Container => Object.Container,
                     Index     => Object.Index,
                     Current   => Object.Container.Data.Colours);
   end First;

   function Next (Object : Iterator; Position : Cursor) return Cursor is
      Next_Ptr : Colour_Array_Pointer.Pointer := Position.Current;
   begin
      Colour_Array_Pointer.Increment (Next_Ptr);

      --  Put_Line ("Next");

      --  if Object.Container /= Position.Container then
      --     raise Program_Error with "Wrong containers";
      --  end if;

      return Cursor'(Container => Object.Container,
                     Index     => Position.Index + 1,
                     Current   => Next_Ptr);
   end Next;
end SDL.Video.Palettes;