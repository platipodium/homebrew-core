class Esmf < Formula
  desc "Earth System Modeling Framework (ESMF)"
  homepage "https://earthsystemmodeling.org"
  url "https://github.com/esmf-org/esmf/archive/refs/tags/ESMF_8_2_0.tar.gz"
  sha256 "3693987aba2c8ae8af67a0e222bea4099a48afe09b8d3d334106f9d7fc311485"
  license "NCSA"

  depends_on "gcc" => "11.1"
  depends_on "netcdf"
  depends_on "open-mpi"

  # Formulae in homebrew/core should use OpenBLAS as the default serial linear,
  # algebra library. For now we test with veclibFort
  depends_on "veclibfort"
  depends_on xcode: "13"
  depends_on "xerces-c"

  def install
    ENV["ESMF_DIR"] = "#{buildpath}.to_s"
    ENV["ESMF_ABI"] = "64.to_s"
    ENV["ESMF_INSTALL_PREFIX"] = "#{prefix}.to_s"

    # Explicitly use the brew-provided mpi wrappers as they are potentially
    # ambiguous
    ENV["ESMF_COMM"] = "openmpi"
    ENV["ESMF_F90COMPILER"] = "#{HOMEBREW_PREFIX}/bin/mpifort"
    ENV["ESMF_CXXCOMPILER"] = "#{HOMEBREW_PREFIX}/bin/mpicxx"

    # We use the system clang and brew-installed gfortran
    ENV["ESMF_COMPILER"] = "gfortranclang"
    ENV["ESMF_F90COMPILEOPTS"] = "-fallow-argument-mismatch -DESMF_NO_SEQUENCE"

    # The netcdf formula potentially installs wrong compiler links, therefore
    # use the "split" option here
    ENV["ESMF_NETCDF"] = "split"
    ENV["ESMF_NETCDF_LIBPATH"] = "#{HOMEBREW_PREFIX}/lib"
    ENV["ESMF_NETCDF_INCLUDE"] = "#{HOMEBREW_PREFIX}/include"

    # Build fails with Apple-provided libc++, therefore switch to gcc libstdc++
    # and include the correct header include path.  Also, ESMF uses some
    # stdlib headers marked as backward, so need to include the backward subdir
    ENV["ESMF_CXXCOMPILEOPTS"]  = "-stdlib=libstdc++"
    ENV["ESMF_CXXCOMPILEOPTS"] += " -stdlib++-isystem#{HOMEBREW_PREFIX}/Cellar"
    ENV["ESMF_CXXCOMPILEOPTS"] += "/gcc/11.2.0_3/include/c++/11"
    ENV["ESMF_CXXCOMPILEOPTS"] += " -stdlib++-isystem#{HOMEBREW_PREFIX}/Cellar"
    ENV["ESMF_CXXCOMPILEOPTS"] += "/gcc/11.2.0_3/include/c++/11/backward"
    ENV["ESMF_CXXCOMPILEOPTS"] += " -stdlib++-isystem#{HOMEBREW_PREFIX}/Cellar"
    ENV["ESMF_CXXCOMPILEOPTS"] += "/gcc/11.2.0_3/include/c++/11/aarch64-apple-darwin21"
    ENV["ESMF_CXXLINKOPTS"]     = " -stdlib=libstdc++"

    # Veclibfort is installed as a dependency, as is xerces-c
    ENV["ESMF_LAPACK"] = "system"
    ENV["ESMF_LAPACK_LIBS"] = "-lveclibFort"
    ENV["ESMF_LAPACK_LIBPATH"] = "#{HOMEBREW_PREFIX}/lib"

    ENV["ESMF_XERCES"] = "standard"

    ENV["ESMF_YAMLCPP"] = "internal"
    ENV["ESMF_PIO"] = "internal"

    # Save some compile time and build space by building lite arrays, i.e.
    # arrays with dimensions < 5 (set this to FALSE to allow up to 7 dimensions)
    ENV["ESMF_ARRAY_LITE"] = "TRUE"

    system "make"

    ENV["ESMF_DIR"] = "#{buildpath}.to_s"
    ENV["ESMF_INSTALL_PREFIX"] = "#{prefix}.to_s"
    system "make", "install"

    ENV["ESMFMKFILE"] = "#{HOMEBREW_PREFIX}/lib/libO/Darwin.gfortranclang.64.openmpi.default/esmf.mk"
    system "echo", "Set", "ESMFMKFILE", "to", ENV["ESMFMKFILE"]
  end

  test do
    ENV["ESMF_DIR"] = "#{buildpath}.to_s"
    ENV["ESMFMKFILE"] = "#{HOMEBREW_PREFIX}/lib/libO/Darwin.gfortranclang.64.openmpi.default/esmf.mk"

    # This is a library, so it is ok to run build-time checks
    system "make", "check"
  end
end
