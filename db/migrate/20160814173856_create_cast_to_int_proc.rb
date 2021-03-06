class CreateCastToIntProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.cast_to_int(text)
        RETURNS integer AS
      $BODY$
      begin
          -- Note the double casting to avoid infinite recursion.
          return cast($1::varchar as integer);
      exception
          when invalid_text_representation then
              return 0;
      end;
      $BODY$
        LANGUAGE plpgsql;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.cast_to_int(text);
    })
  end
end
