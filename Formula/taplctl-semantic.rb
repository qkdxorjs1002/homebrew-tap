class TaplctlSemantic < Formula
  include Language::Python::Virtualenv

  desc "Codex workflow harness with semantic search dependencies"
  homepage "https://github.com/qkdxorjs1002/tapl"
  url "https://github.com/qkdxorjs1002/tapl/releases/download/0.9.4/taplctl-0.9.4-py3-none-any.whl"
  version "0.9.4"
  sha256 "99188b8712a89a538d8cff01d1e3c43b3b14aa68e5950f5dd81b17fee0c39876"
  license "MIT"
  head "https://github.com/qkdxorjs1002/tapl.git", branch: "main"

  depends_on "libyaml"
  depends_on "python@3.12"

  conflicts_with "taplctl", because: "both install the taplctl executable"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/ad/fe/c0a6b7b2ca128a8fb228575147073b660656734b8ebe4d76c8fd748dcc79/numpy-2.4.6-cp312-cp312-macosx_14_0_arm64.whl"
    sha256 "3213d622a0283a39a93d188f3cf72b26862df52fbb4ca3697f51705016523d41"
  end

  resource "sentence-transformers" do
    url "https://files.pythonhosted.org/packages/76/c1/dc1582b79e9a2eb0cddf9559cd9bcdff084f541d6fe881fdd9d98630dba7/sentence_transformers-5.6.0-py3-none-any.whl"
    sha256 "d2075b5e687a1611005e20ab04a6846994d51adfcf39610aed066af3c0c0b81f"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/df/56/bbd60dd8668055803bf8ba55a81f9b8a8b31497f620109a9671d26a2076d/transformers-5.12.1-py3-none-any.whl"
    sha256 "2a5e109d2021265df7098ffbb738295acaf5ad256f12cbc586db2ea4dcbb1a8a"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/b2/a5/558da89f66464d8d0229ff497e8b8666977de2d8cf48c28a2862ecf1250f/huggingface_hub-1.19.0-py3-none-any.whl"
    sha256 "1dc72e1f6b4d6df6b30eb72e57d00514ef453d660f04af2b87f0e67267f31ee0"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/35/94/4b2ecfbad8f8b04701a23aefb62f540b9137d058b7e1dbef16a32676f0e9/hf_xet-1.5.1-cp37-abi3-macosx_11_0_arm64.whl"
    sha256 "94e761bbd266bf4c03cee73753916062665ce8365aa40ed321f45afcb934b41e"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/2a/39/e50c7c3a983047577ee07d2a9e53faf5a69493943ec3f6a384bdc792deb2/httpx-0.28.1-py3-none-any.whl"
    sha256 "d909fcccc110f8c7faf814ca82a9a4d816bc5a6dbfea25d6591d6985b8ba59ad"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/7e/f5/f66802a942d491edb555dd61e3a9961140fd64c90bce1eafd741609d334d/httpcore-1.0.9-py3-none-any.whl"
    sha256 "2d400746a40668fc9dec9810239072b40b4484b640a8c38fd654a024c7a1bf55"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/2e/47/174dca0502ef88b28f1c9e06b73ce33500eedfac7a7692108aec220464e7/tokenizers-0.22.2-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "1e418a55456beedca4621dbab65a318981467a2b188e982a23e117f115ce5001"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/3f/f9/2b3ff4e56e5fa7debfaf9eb135d0da96f3e9a1d5b27222223c7296336e5f/typer-0.25.1-py3-none-any.whl"
    sha256 "75caa44ed46a03fb2dab8808753ffacdbfea88495e74c85a28c5eefcf5f39c89"
  end

  resource "sqlite-vec" do
    url "https://files.pythonhosted.org/packages/a4/3d/3677e0cd2f92e5ebc43cd29fbf565b75582bff1ccfa0b8327c7508e1084f/sqlite_vec-0.1.9-py3-none-macosx_11_0_arm64.whl"
    sha256 "1d52e30513bae4cc9778ddbf6145610434081be4c3afe57cd877893bad9f6b6c"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/1e/d3/26bf1008eb3d2daa8ef4cacc7f3bfdc11818d111f7e2d0201bc6e3b49d45/annotated_doc-0.0.4-py3-none-any.whl"
    sha256 "571ac1dc6991c450b25a9c2d84a3705e2ae7a53467b5d111c24fa8baabbed320"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0d/67e5b4109ea4a837e80daa87c2c696711955e40449a97e8926672534def2/click-8.4.1-py3-none-any.whl"
    sha256 "482be17c6991b8c19c5429a1e995d9b0efdbb63172824c41f99965dc0ade8ec2"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/13/37/a065dc3bd6e49423a6532c642ca7378d3f467b1ef44c2800c937af7f9739/filelock-3.29.4-py3-none-any.whl"
    sha256 "dac1648087d5115554850d113e7dd8c83ab2d38e3435dde2d4f163847e57b767"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/e5/22/4222d7ddf3da30f363edaa98e329c2bce6c65497c9cb2810931c8b2c0fbc/fsspec-2026.6.0-py3-none-any.whl"
    sha256 "02e0b71817df9b2169dc30a16832045764def1191b43dcff5bb85bdee212d2a1"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/04/4b/29cac41a4d98d144bf5f6d33995617b185d14b22401f75ca86f384e87ff1/h11-0.16.0-py3-none-any.whl"
    sha256 "63cf8bbe7522de3bf65932fda1d9c2772064ffb3dae62d55932da54b31cb6c86"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/b2/87e62e8c3e2f4b32e5fe99e0b86d576da1312593b39f47d8ceef365e95ed/packaging-26.2-py3-none-any.whl"
    sha256 "5fc45236b9446107ff2415ce77c807cee2862cb6fac22b8a73826d0693b0980e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/89/a0/6cf41a19a1f2f3feab0e9c0b74134aa2ce6849093d5517a0c550fe37a648/pyyaml-6.0.3-cp312-cp312-macosx_11_0_arm64.whl"
    sha256 "fc09d0aa354569bc501d4e787133afc08552722d3ab34836a80547331bb5d4a0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/54/4b/ee27938d1b2c443e89a9a10e00d2d19aa5ee300cd3d61140644e93bb083e/regex-2026.5.9-cp312-cp312-macosx_11_0_arm64.whl"
    sha256 "f7a7c26137296beba7784de6eba69c6a93a63ccebc385e4962fe67e267a91225"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/82/3b/64d4899d73f91ba49a8c18a8ff3f0ea8f1c1d75481760df8c68ef5235bf5/rich-15.0.0-py3-none-any.whl"
    sha256 "33bd4ef74232fb73fe9279a257718407f169c09b78a87ad3d296f548e27de0bb"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/f4/7e/a72dd26f3b0f4f2bf1dd8923c85f7ceb43172af56d63c7383eb62b332364/pygments-2.20.0-py3-none-any.whl"
    sha256 "81a9e26dd42fd28a23a2d169d86d7ac03b46e2f8b59ed4698fb4785f946d0176"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/b3/81/4da04ced5a082363ecfa159c010d200ecbd959ae410c10c0264a38cac0f5/markdown_it_py-4.2.0-py3-none-any.whl"
    sha256 "9f7ebbcd14fe59494226453aed97c1070d83f8d24b6fc3a3bcf9a38092641c4a"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/b3/38/89ba8ad64ae25be8de66a6d463314cf1eb366222074cfda9ee839c56a4b4/mdurl-0.1.2-py3-none-any.whl"
    sha256 "84008a41e51615a49fc9966191ff91509e3c40b939176e643fd50a5c2196b8f8"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/f5/b1/fa7c600e7dceae12e9606c7578cbc9ff1e1ed55844883ee5c92205e86226/safetensors-0.8.0-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "c80201d22cbf405b80647a60ada77bba06c8fba2da2743ba1e89cdcc39a81f25"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/cc/d5/2b5148f2279196775e1db2aeb85d14b70ac80e7e32b3b28e7ebeafb0901d/scikit_learn-1.9.0-cp312-cp312-macosx_12_0_arm64.whl"
    sha256 "5be45aa4a42a68a533913a6ed736cf309de2226411c79ef8d609a5456f1939b1"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/7b/91/984aca2ec129e2757d1e4e3c81c3fcda9d0f85b74670a094cc443d9ee949/joblib-1.5.3-py3-none-any.whl"
    sha256 "5fc3c5039fc5ca8c0276333a188bbd59d6b7ab37fe6632daa76bc7f9ec18e713"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/48/ca/36339329c4604adbcc99c899b7eb1ce1a555c499b6a6860757dc9bfed36d/narwhals-2.22.1-py3-none-any.whl"
    sha256 "60567d774edf77db53906f89d9fbd164e66e56d66d388e1e6990f17ac33cfb53"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/cf/a9/599c28631bad314d219cf9ffd40e985b24d603fc8a2f4ccc5ae8419a535b/scipy-1.17.1-cp312-cp312-macosx_14_0_arm64.whl"
    sha256 "cc90d2e9c7e5c7f1a482c9875007c095c3194b1cfedca3c2f3291cdc2bc7c086"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/e0/f9/0595336914c5619e5f28a1fb793285925a8cd4b432c9da0a987836c7f822/shellingham-1.5.4-py2.py3-none-any.whl"
    sha256 "7ecfff8f2fd72616f7481040475a65b2bf8af90a56c89140852d1120324e8686"
  end

  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/32/d5/f9a850d79b0851d1d4ef6456097579a9005b31fea68726a4ae5f2d82ddd9/threadpoolctl-3.6.0-py3-none-any.whl"
    sha256 "43a0b8fd5a2928500110039e43a5eed8480b918967083ea48dc3ab9f13c4a7fb"
  end

  resource "torch" do
    url "https://files.pythonhosted.org/packages/ef/bb/285d643f254731294c9b595a007eac39db4600a98682d7bca688f42ca164/torch-2.12.0-cp312-cp312-macosx_14_0_arm64.whl"
    sha256 "b41339df93d491435e790ff8bcbae1c0ce777175889bfd1281d119862793e6a2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/e1/e3/c164c88b2e5ce7b24d667b9bd83589cf4f3520d97cad01534cd3c4f55fdb/setuptools-81.0.0-py3-none-any.whl"
    sha256 "fdd925d5c5d9f62e4b74b30d6dd7828ce236fd6ed998a08d81de62ce5a6310d6"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/9e/c9/b2622292ea83fbb4ec318f5b9ab867d0a28ab43c5717bb85b0a5f6b3b0a4/networkx-3.6.1-py3-none-any.whl"
    sha256 "d47fbf302e7d9cbbb9e2555a0d267983d2aa476bac30e90dfbe5669bd57f3762"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/a2/09/77d55d46fd61b4a135c444fc97158ef34a095e5681d0a6c10b75bf356191/sympy-1.14.0-py3-none-any.whl"
    sha256 "e091cc3e99d2141a0ba2847328f5479b05d94a6635cb96148ccb3f34671bd8f5"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/43/e3/7d92a15f894aa0c9c4b49b8ee9ac9850d6e63b03c9c32c0367a13ae62209/mpmath-1.3.0-py3-none-any.whl"
    sha256 "a0b2b9fe80bbcd81a6647ff13108738cfb482d481d826cc0e02f5b35e5c88d2c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/eb/75/1a0392bcc21c44dcdf87b3cf2d137e7829be2c083a1e38d44efca3d57a16/tqdm-4.68.2-py3-none-any.whl"
    sha256 "d4240441fb5353290b87d6a85968c9decc131a99b8c7faa28269d829de669ede"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/18/67/36e9267722cc04a6b9f15c7f3441c2363321a3ea07da7ae0c0707beb2a9c/typing_extensions-4.15.0-py3-none-any.whl"
    sha256 "f0fa19c6845758ab08074a0cfa8b7aecb71c999ca73d62883bc25cc018c4e548"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/ba/16/9826f089383c593cdfc4a6e5aca94d9e91ae1692c57af82c3b2aa5e810f7/anyio-4.14.0-py3-none-any.whl"
    sha256 "dd9b7a2a9799ed6552fde617b2c5df02b7fdd7d88392fc48101e51bae46164d9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1e/5e/d4e9f1a599fb8e573b7b87160658329fbf28d19eac2718f51fc3def3aa5a/idna-3.18-py3-none-any.whl"
    sha256 "7f952cbe720b688055e3f87de14f5c3e5fdaa8bc3928985c4077ca689de849a2"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/59/8c/57e832b7af6d7c5abe66eb3fbe3a3a32f4d11ea23a1aa7131371035be991/certifi-2026.5.20-py3-none-any.whl"
    sha256 "3c52e209ba0a4ad7aebe60436a4ab349c39e1e602e8c134221e546902ad25897"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/62/a1/3d680cbfd5f4b8f15abc1d571870c5fc3e594bb582bc3b64ea099db13e56/jinja2-3.1.6-py3-none-any.whl"
    sha256 "85ece4451f492d0c13c5dd7c13a64681a86afae63a5f347908daf103ce6d2f67"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/9a/81/7e4e08678a1f98521201c3079f77db69fb552acd56067661f8c2f534a718/markupsafe-3.0.3-cp312-cp312-macosx_11_0_arm64.whl"
    sha256 "1872df69a4de6aead3491198eaf13810b565bdbeec3ae2dc8780f14458ec73ce"
  end

  def install
    wheel = Pathname.glob("*.whl").first
    raise "Could not find taplctl wheel" unless wheel

    wheelhouse = buildpath/"wheelhouse"
    wheelhouse.mkpath
    resources.each do |resource|
      resource.stage { wheelhouse.install Dir["*.whl"] }
    end

    virtualenv_create(libexec, "python3.12", system_site_packages: false)
    system "python3.12", "-m", "pip", "--python=#{libexec}/bin/python", "install",
           "--no-index", "--find-links=#{wheelhouse}", "--no-compile", wheel
    bin.install_symlink libexec/"bin/taplctl"
  end

  service do
    run [opt_bin/"taplctl", "searchd", "run"]
    keep_alive true
  end

  test do
    assert_match(/\Ataplctl \d+\.\d+\.\d+\z/, shell_output("#{bin}/taplctl --version").strip)
    assert_match(/"numpy": true/, shell_output("#{bin}/taplctl doctor --json"))
    system bin/"taplctl", "install", "repo", "--repo", testpath, "--taplctl-command", bin/"taplctl", "--json"
    assert_path_exists testpath/".codex/hooks.json"
    assert_path_exists testpath/".tapl/config.toml"
    assert_path_exists testpath/".tapl/tapl.db"
  end
end
