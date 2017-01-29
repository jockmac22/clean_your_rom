module Cyr
  module Views

    # Since editing and selecting are the same interaction, just different
    # flow states, we just have to give the select state a name that matches
    # and inherit the edit state.
    class SelectDevice < Cyr::Views::EditDevice; end
    
  end
end
