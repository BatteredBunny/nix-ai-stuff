{ fetchFromGitHub, pkgs, lib }: rec {
  version = "0.4.0";
  github = fetchFromGitHub
    {
      owner = "chaiNNer-org";
      repo = "spandrel";
      rev = "v${version}";
      hash = "sha256-BiC4gmRsNkRAUonKHV7U/hvOP00pIPtm40ydmSlNDCI=";
    };
  meta = with lib; {
    description = "Spandrel gives your project support for various PyTorch architectures meant for AI Super-Resolution, restoration, and inpainting. Based on the model support implemented in chaiNNer";
    homepage = "https://github.com/chaiNNer-org/spandrel";
    changelog = "https://github.com/chaiNNer-org/spandrel/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

  spandrel = pkgs.callPackage ./spandrel.nix { inherit version github meta; };
  spandrel_extra_arches = pkgs.callPackage ./spandrel_extra_arches.nix { inherit version github meta spandrel; };
}
