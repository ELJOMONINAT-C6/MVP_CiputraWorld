//
//  EquipmentData.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 27/08/25.
//

import Foundation

let equipmentList: [Equipment] = [

    // AC
    Equipment(
        assetID: "AC-001",
        namaAlat: "AC Split Ruangan",
        lokasiPemasangan: "Lantai 1 – Lobby Utama dekat Tenant A",
        tanggalInstalasi: "2022-03-15",
        masaGaransi: "2025-03-15",
        spesifikasi: [
            "Merk": "Daikin",
            "Tipe Model": "FTKQ50UVM4",
            "Kapasitas": "2 PK",
            "Serial Number": "DK12345L1",
            "xPosition": "120",
            "yPosition": "80"
        ]
    ),
    Equipment(
        assetID: "AC-002",
        namaAlat: "AC Cassette",
        lokasiPemasangan: "Lantai 1 – Area Foodcourt dekat Tenant B",
        tanggalInstalasi: "2021-07-10",
        masaGaransi: "2024-07-10",
        spesifikasi: [
            "Merk": "Panasonic",
            "Tipe Model": "S-3448PU3H",
            "Kapasitas": "4 PK",
            "Serial Number": "PN98765F2",
            "xPosition": "200",
            "yPosition": "150"
        ]
    ),
    Equipment(
        assetID: "AC-003",
        namaAlat: "AC Central",
        lokasiPemasangan: "Lantai 1 – Area Bioskop dekat Tenant C",
        tanggalInstalasi: "2020-11-05",
        masaGaransi: "2023-11-05",
        spesifikasi: [
            "Merk": "LG",
            "Tipe Model": "ARNU243TMC4",
            "Kapasitas": "10 PK",
            "Serial Number": "LG56789B3",
            "xPosition": "250",
            "yPosition": "250"
        ]
    ),

    // HCU
    Equipment(
        assetID: "HCU-001",
        namaAlat: "HCU Air Handling Unit",
        lokasiPemasangan: "Lantai 1 – Basement Utility Room dekat Tenant D",
        tanggalInstalasi: "2021-08-12",
        masaGaransi: "2024-08-12",
        spesifikasi: [
            "Merk": "Trane",
            "Tipe Model": "HCU-TN350",
            "Kapasitas": "350 L/s",
            "Serial Number": "TNHCU12345",
            "xPosition": "80",
            "yPosition": "300"
        ]
    ),
    Equipment(
        assetID: "HCU-002",
        namaAlat: "HCU Chiller Room",
        lokasiPemasangan: "Lantai 1 – Area Chiller Plant dekat Tenant E",
        tanggalInstalasi: "2020-02-25",
        masaGaransi: "2023-02-25",
        spesifikasi: [
            "Merk": "Carrier",
            "Tipe Model": "HCU-CR600",
            "Kapasitas": "600 L/s",
            "Serial Number": "CRHCU67890",
            "xPosition": "180",
            "yPosition": "320"
        ]
    ),
    Equipment(
        assetID: "HCU-003",
        namaAlat: "HCU AHU Corridor",
        lokasiPemasangan: "Lantai 1 – Koridor Utama dekat Tenant F",
        tanggalInstalasi: "2022-06-30",
        masaGaransi: "2025-06-30",
        spesifikasi: [
            "Merk": "York",
            "Tipe Model": "HCU-YK420",
            "Kapasitas": "420 L/s",
            "Serial Number": "YKHCU24680",
            "xPosition": "260",
            "yPosition": "350"
        ]
    ),

    // CCTV
    Equipment(
        assetID: "CCTV-001",
        namaAlat: "CCTV Dome Indoor",
        lokasiPemasangan: "Lantai 1 – Lobby Utama dekat Tenant A",
        tanggalInstalasi: "2022-01-18",
        masaGaransi: "2025-01-18",
        spesifikasi: [
            "Merk": "Hikvision",
            "Tipe Model": "DS-2CD1123G0-I",
            "Resolusi": "2 MP (1080p)",
            "Serial Number": "HKCCTV001",
            "xPosition": "100",
            "yPosition": "120"
        ]
    ),
    Equipment(
        assetID: "CCTV-002",
        namaAlat: "CCTV Bullet Outdoor",
        lokasiPemasangan: "Lantai 1 – Area Parkir dekat Tenant G",
        tanggalInstalasi: "2021-09-05",
        masaGaransi: "2024-09-05",
        spesifikasi: [
            "Merk": "Dahua",
            "Tipe Model": "HAC-HFW1200TLP",
            "Resolusi": "2 MP (1080p)",
            "Serial Number": "DHCCTV002",
            "xPosition": "300",
            "yPosition": "200"
        ]
    ),
    Equipment(
        assetID: "CCTV-003",
        namaAlat: "CCTV PTZ (Pan-Tilt-Zoom)",
        lokasiPemasangan: "Lantai 1 – Area Bioskop dekat Tenant C",
        tanggalInstalasi: "2020-12-22",
        masaGaransi: "2023-12-22",
        spesifikasi: [
            "Merk": "Axis",
            "Tipe Model": "Q6075-E PTZ",
            "Resolusi": "2 MP (HD 1080p) dengan 40x Zoom",
            "Serial Number": "AXCCTV003",
            "xPosition": "320",
            "yPosition": "100"
        ]
    )
]
