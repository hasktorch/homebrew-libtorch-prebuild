class LibtorchPrebuildAT23 < Formula
  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://download.pytorch.org/libtorch/cpu/libtorch-macos-arm64-2.3.0.zip"
  sha256 "ff86ea62ac24a27bba31490d95a8fab6beab8aab5abe72978300568c49bf2150"
  license "BSD-3-Clause"

  def install
    system "bash", "-c", "cd include/torch; for i in csrc/api/include/torch/* ; do ln -s $i ;done"
    system "bash", "-c", "install -d #{include}"
    system "bash", "-c", "install -d #{lib}"
    system "bash", "-c", "install -d #{share}"
    system "bash", "-c", "cp -a include/* #{include}"
    system "bash", "-c", "cp -a lib/* #{lib}"
    system "bash", "-c", "cp -a share/* #{share}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10", "test.cpp", "-o", "test"
    system "./test"
  end
end
