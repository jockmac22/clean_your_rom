require 'yaml'

module Cyr
  VERSION     = "1.0.0"

  COUNTRIES   = {
    au:     { code: "(A)",    name: "A - Australia",            match: /\(A\)/ },
    ch:     { code: "(C)",    name: "C - China",                match: /\(C\)/ },
    eu:     { code: "(E)",    name: "E - Europe",               match: /\(E\)/ },
    fr:     { code: "(F)",    name: "F - France",               match: /\(F\)/ },
    fc:     { code: "(FC)",   name: "FC - French Canadian",     match: /\(FC\)/ },
    fi:     { code: "(FN)",   name: "FN - Finland",             match: /\(FN\)/ },
    de:     { code: "(G)",    name: "G - Germany",              match: /\(G\)/ },
    gr:     { code: "(GR)",   name: "GR - Greece",              match: /\(GR\)/ },
    h:      { code: "(H)",    name: "H - Holland",              match: /\(H\)/ },
    it:     { code: "(I)",    name: "I - Italy",                match: /\(I\)/ },
    jp:     { code: "(J)",    name: "J - Japan",                match: /\(J\)/ },
    kr:     { code: "(K)",    name: "K - Korea",                match: /\(K\)/ },
    nl:     { code: "(NL)",   name: "NL - Netherlands",         match: /\(NL\)/ },
    pd:     { code: "(PD)",   name: "PD - Public Domain",       match: /\(PD\)/ },
    sp:     { code: "(S)",    name: "S - Spain",                match: /\(S\)/ },
    se:     { code: "(SW)",   name: "SW - Sweden",              match: /\(SW\)/ },
    us:     { code: "(U)",    name: "U - USA",                  match: /\(U\)/ },
    gb:     { code: "(UK)",   name: "UK - England",             match: /\(UK\)/ },
    hk:     { code: "(HK)",   name: "HK - Hong Kong",           match: /\(HK\)/ },
    jp_kr:  { code: "(1)",    name: "1 - Japan & Korea",        match: /\(1\)/ },
    us_br:  { code: "(4)",    name: "4 - USA & Brazil NTSC",    match: /\(4\)/ },
    nus:    { code: "(B)",    name: "B - Non USA (Genesis)",    match: /\(B\)/ },
    unk:    { code: "(Unk)",  name: "Unk - Unknown Country",    match: /\(Unk\)/ }
  }

  CODES       =  {
    alt:    { code: "[a]",    name: "a - Alternate",            match: /\[(a|a[0-9]+)\]/ },
    pir:    { code: "[p]",    name: "p - Pirate",               match: /\[p\]/ },
    bad:    { code: "[b]",    name: "b - Bad Dump",             match: /\[(b|b\s+|b[0-9]+)\]/ },
    trn:    { code: "[t]",    name: "t - Trained",              match: /\[(t|t(\s+|[0-9]+|[0-9]+[^\]]+))\]/ },
    fix:    { code: "[f]",    name: "f - Fixed",                match: /\[(f|f\s+|f[0-9]+)\]/ },
    trans:  { code: "[T]",    name: "T - Translation",          match: /\[(T|T(\+|\-)[^\]]+)\]/ },
    hack:   { code: "[h]",    name: "H - Hack",                 match: /\[(h|h(\s+|[0-9]+|[0-9]+[^\]]+))\]/ },
    unk:    { code: "(-)",    name: "- - Uknown Year",          match: /\(-\)/ },
    ovr:    { code: "[o]",    name: "o - Overdump",             match: /\[(o|o\s+|o[0-9]+)\]/ },
    ver:    { code: "[!]",    name: "! - Verified Good",        match: /\[!\]/ },
    mult:   { code: "(M#)",   name: "M# - Multilanguage",       match: /\(M[0-9]+\)/ },
    check:  { code: "(###)",  name: "### - Checksum",           match: /\([0-9]+\)/ },
    beta:   { code: "(Beta)",  name: "Beta - Beta Release",     match: /\(beta\)/i },
    ntsc:   { code: "(NTSC)", name: "NTSC - Video Standard",    match: /\(NTSC\)/ },
    pal:    { code: "(PAL)",  name: "PAL - Video Standard",     match: /\(PAL\)/ },
    size:   { code: "(??k)",  name: "??k - ROM Size",           match: /\([0-9]+k\)/ },
    uncl:   { code: "ZZZ_",   name: "ZZZ_ - Unclassified",      match: /ZZZ_/ },
    unl:    { code: "(Unl)",  name: "Unl - Unlicensed",         match: /\(Unl\)/ }
  }

  ALL_CODES   = COUNTRIES.merge(CODES)

  class Cleanr

    attr_reader :config, :company_key, :device_key
    attr_accessor :company, :device

    def initialize p={}
      @config = YAML.load_file("#{File.dirname(__FILE__)}/../config/config.yml").deep_symbolize_keys
      @working_path = Dir.pwd
      add_include_code(p[:include])   if p[:include]
      add_include_codes(p[:includes]) if p[:includes]
      add_exclude_code(p[:exclude])   if p[:exclude]
      add_exclude_codes(p[:excludes]) if p[:excludes]
    end

    def base_path
      @base_path ||= Dir.pwd
    end

    def base_path= path
      @base_path = path
    end

    def device_path device
      "#{base_path}/#{device[:folder]}"
    end

    def default_source_path
      return "#{roms_path}/_source"
    end

    def source_path
      @source_path || default_source_path
    end

    def source_path= path
      @source_path = nil  if      (path == default_source_path)     # The path can be derived, no need to have a fixed value.
      @source_path = path unless  (path == default_source_path)     # The path is specified by the user and different than the default
    end

    def default_alternates_path
      return "#{roms_path}/_alternates"
    end

    def alternates_path
      @alternates_path || default_alternates_path
    end

    def alternates_path= path
      @alternates_path = nil  if      (path == default_alternates_path)     # The path can be derived, no need to have a fixed value.
      @alternates_path = path unless  (path == default_alternates_path)     # The path is specified by the user and different than the default
    end

    def default_duplicates_path
      return "#{roms_path}/_duplicates"
    end

    def duplicates_path
      @duplicates_path || default_duplicates_path
    end

    def duplicates_path= path
      @duplicates_path = nil  if      (path == default_duplicates_path)     # The path can be derived, no need to have a fixed value.
      @duplicates_path = path unless  (path == default_duplicates_path)     # The path is specified by the user and different than the default
    end

    def default_roms_path
      return "#{base_path}" if device.nil?
      "#{device_path(device)}"
    end

    def roms_path
      @roms_path || default_roms_path
    end

    def roms_path= path
      @roms_path = nil  if      (path == default_roms_path)     # The path can be derived, no need to have a fixed value.
      @roms_path = path unless  (path == default_roms_path)     # The path is specified by the user and different than the default
    end

    def companies
      list = []
      @config[:companies].each do |console|
        key = console[0]
        console = console[1]
        list << [key, console[:name]]
      end
      list
    end

    def company= key
      @company_key = key
      @company = nil
    end

    def company
      @company ||= @company_key.nil? ? nil : @config[:companies][@company_key]
    end

    def devices company_key
      list = []
      @config[:companies][company_key.to_sym][:devices].each do |device|
        key = device[0]
        device = device[1]
        list << [key, device[:name]]
      end
      list
    end

    def device= key
      @device = nil
      @device_key = (self.company.nil? ? nil : key)
    end

    def device
      @device ||= (@device_key.nil? || self.company.nil?) ? nil : self.company[:devices][@device_key]
    end

    def include_codes
      @include_codes ||= []
    end

    def include_codes_str
      self.include_codes.map{ |key| COUNTRIES.keys.include?(key) ? COUNTRIES[key][:code] : (CODES.keys.include?(key) ? CODES[key][:code] : nil) }.join(" ")
    end

    def add_include_code key
      return if self.include_codes.include?(key)
      return unless (COUNTRIES.has_key?(key) || CODES.has_key?(key))
      self.remove_exclude_code(key)
      self.include_codes << key
    end

    def add_include_codes keys
      return unless keys.is_a?(Array)
      keys.each{ |key| self.add_include_code(key) }
    end

    def remove_include_code key
      self.include_codes.delete(key)
    end

    def remove_include_codes keys
      return unless keys.is_a?(Array)
      keys.each{ |key| self.remove_include_code(key) }
    end

    def exclude_codes
      @exclude_codes ||= []
    end

    def exclude_codes_str
      self.exclude_codes.map{ |key| COUNTRIES.keys.include?(key) ? COUNTRIES[key][:code] : (CODES.keys.include?(key) ? CODES[key][:code] : nil) }.join(" ")
    end

    def add_exclude_code key
      return if self.exclude_codes.include?(key)
      return unless ALL_CODES.has_key?(key)
      self.remove_include_code(key)
      self.exclude_codes << key
    end

    def add_exclude_codes keys
      return unless keys.is_a?(Array)
      keys.each{ |key| self.add_exclude_code(key) }
    end

    def remove_exclude_code key
      self.exclude_codes.delete(key)
    end

    def remove_exclude_codes keys
      return unless keys.is_a?(Array)
      keys.each{ |key| self.remove_exclude_code(key) }
    end

    def include_file path
      file = Pathname.new(path)
      return false unless file.file?

      file = file.basename.to_s
      incl = false
      excl = false

      self.include_codes.each{ |key| incl = (ALL_CODES.has_key?(key) && !(ALL_CODES[key][:match] =~ file).nil?); break if incl }
      self.exclude_codes.each{ |key| excl = (ALL_CODES.has_key?(key) && !(ALL_CODES[key][:match] =~ file).nil?); break if excl }

      return (incl && !excl)
    end

    def skip_code key
      self.remove_include_code(key)
      self.remove_exclude_code(key)
    end

    def skip_codes keys
      self.remove_include_codes(keys)
      self.remove_exclude_codes(keys)
    end

    def clean

      # ROMS Path
      invalid_path("ROMS", roms_path) unless Dir.exists?(roms_path)

      # Source Path
      invalid_path("source", source_path) unless Dir.exists?(source_path)

      # Alternates Path
      invalid_path("alternates", alternates_path) unless Dir.exists?(alternates_path)

      # Duplicates Path
      invalid_path("duplicates", duplicates_path) unless Dir.exists?(duplicates_path)

      # Files
      # A list of files that match the extension.
      files           = []
      device[:extensions].each{ |ext| files += Dir["#{source_path}/**/*#{ext}"] }

      rom_files       = []
      alternate_files = []
      duplicate_files = []
      file_count      = files.length

      # Sort files into roms and alternates
      files.each{ |file| self.include_file(file) ? rom_files << file : alternate_files << file }

      # Copy all of the alternates to the alternates directory
      copy_files(alternate_files, alternates_path,  "Alternate Files")

      duplicate_files = find_duplicates(rom_files)
      rom_files = rom_files - duplicate_files

      duplicate_count = duplicate_files.length
      copy_files(duplicate_files, duplicates_path,  "Duplicates     ") if (duplicate_count > 0)

      count = rom_files.length
      copy_files(rom_files, roms_path,              "ROMS           ")

    end

    protected def invalid_path key, path
      raise "The #{key} path is not valid: #{path}"
    end

    protected def copy_files files, destination, label=nil
      return if files.nil? or (files.length == 0)
      files.sort!{ |a, b| a.split("/").last.length <=> b.split("/").last.length }
      count = files.length
      files.each_with_index do |file, idx|
        print "\r" + "#{"#{label.light_white} | " if label}" + "Copying [#{idx+1}/#{count}] #{file.split("/").last}...    ".light_cyan
        FileUtils.cp(file, destination)
      end
      print "\r#{" "*files.last.length}\r" unless files.nil? or (files.length == 0)
      puts "\r" + "#{"#{label.light_white} | " if label}" + "#{files.length} files copied.".light_cyan
    end

    protected def find_duplicates files
      files.sort!
      duplist = {}

      files.each do |file|
        dir = File.dirname(file)
        duplist[dir] ||= []
        duplist[dir] << file
      end

      duplist = duplist.select{ |dir, files| (files.length > 1) }
      duplist = duplist.to_a.map{ |dup| dup[1] }.flatten

      duplist
    end

  end
end
