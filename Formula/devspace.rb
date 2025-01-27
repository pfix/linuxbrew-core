class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.0.3",
    :revision => "2743f0af1dd51cfd340497c7476b6a2abd341479"

  bottle do
    cellar :any_skip_relocation
    sha256 "f20d9dfeea269010007a64eea502e571c2cacf07e7bbad176fb0347dc42b2b0b" => :catalina
    sha256 "ed5c835a02ee2f9b5e9de0efd6743adbe8d449ac0de1e653e7c2bd041c568957" => :mojave
    sha256 "c3f0b5cd3f43d2843ab1b3774c13805412ada682387fbc74223d7942af4e35dd" => :high_sierra
    sha256 "72e8a9161de0c8037933ee026ea912cc279c6809c5b8a7bfdc85417d92d4b389" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/devspace-cloud/devspace"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"devspace"
      prefix.install_metafiles
    end
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
