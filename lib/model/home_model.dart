class HeaderModel {
  String judul;
  String deskripsi;
  String gambar;

  HeaderModel({this.deskripsi, this.gambar, this.judul});
}

List<HeaderModel> dataHeaderModel = <HeaderModel>[
  HeaderModel(
      deskripsi: "Bersama CWH bantu teman kita yang membutuhkan",
      gambar: null,
      judul: "Bersama CWH bantu sesama"),
  HeaderModel(
      deskripsi:
          "Bantu para siswa melalui donasi pendidikan yang kami sediakan",
      gambar: null,
      judul: "Bantu para siswa melalui donasi"),
  HeaderModel(
      deskripsi:
          "CWH juga menyediakan halaman untuk teman-teman membantu korban bencana",
      gambar: null,
      judul: "Bantu saudara kita korban bencana"),
];
