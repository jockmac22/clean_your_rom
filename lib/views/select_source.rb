module Cyr
  module Views

    # Since editing and selecting are the same interaction, just different
    # flow states, we just have to give the select state a name that matches
    # and inherit the edit state.
    class SelectSource < Cyr::Views::EditSource; end
    
  end
end
