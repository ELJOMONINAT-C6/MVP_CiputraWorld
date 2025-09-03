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

//Data from CW
class EquipmentStore: ObservableObject {
    @Published var equipments: [sampleEquipment] = [
        
        //AHU
        sampleEquipment(
            assetID: "AHU.BS.2",
            assetName: "AHU",
            assetLocation: "LG - IKEA",
            assetSpecification: [
                "Tipe Unit": "CS 270",
                "Cooling Load (Btu/h)": "678,000",
                "Sensible Load (Btu/h)": "448,900",
                "Supply Air Flow (CFM)": "19,550",
                "Outdoor Air Flow (CFM)": "3,500",
                "Water Flow Rate (GPM)": "135.7",
                "Power Input (kW)": "6.34 KwH",
                "xPosition": "120",
                "yPosition": "80"
            ],
            imagePath: "AHU_1"
        ),
        sampleEquipment(
            assetID: "AHU.GF.5",
            assetName: "AHU",
            assetLocation: "GF - EXTERNAL EAST LOBBY",
            assetSpecification: [
                "Tipe Unit": "CS 217",
                "Cooling Load (Btu/h)": "775,200",
                "Sensible Load (Btu/h)": "513,700",
                "Supply Air Flow (CFM)": "21,550",
                "Outdoor Air Flow (CFM)": "3,950",
                "Water Flow Rate (GPM)": "155.1",
                "Power Input (kW)": "18.34 KwH",
                "xPosition": "200",
                "yPosition": "150"
            ],
            imagePath: "AHU_2-5"
        ),
        sampleEquipment(
            assetID: "AHU.GF.6",
            assetName: "AHU",
            assetLocation: "GF - EXTERNAL EAST LOBBY",
            assetSpecification: [
                "Tipe Unit": "CS 217",
                "Cooling Load (Btu/h)": "775,200",
                "Sensible Load (Btu/h)": "513,700",
                "Supply Air Flow (CFM)": "21,550",
                "Outdoor Air Flow (CFM)": "3,950",
                "Water Flow Rate (GPM)": "155.1",
                "Power Input (kW)": "18.34 KwH",
                "xPosition": "250",
                "yPosition": "250"
            ],
            imagePath: "AHU_2-5"
        ),
        sampleEquipment(
            assetID: "AHU.GF.4",
            assetName: "AHU",
            assetLocation: "GF - ZONE A",
            assetSpecification: [
                "Tipe Unit": "CS 217",
                "Cooling Load (Btu/h)": "775,200",
                "Sensible Load (Btu/h)": "513,700",
                "Supply Air Flow (CFM)": "21,550",
                "Outdoor Air Flow (CFM)": "3,950",
                "Water Flow Rate (GPM)": "155.1",
                "Power Input (kW)": "18.34 KwH",
                "xPosition": "80",
                "yPosition": "300"
            ],
            imagePath: "AHU_2-5"
        ),
        sampleEquipment(
            assetID: "AHU.GF.3",
            assetName: "AHU",
            assetLocation: "GF - ZONE A",
            assetSpecification: [
                "Tipe Unit": "CS 217",
                "Cooling Load (Btu/h)": "775,200",
                "Sensible Load (Btu/h)": "513,700",
                "Supply Air Flow (CFM)": "21,550",
                "Outdoor Air Flow (CFM)": "3,950",
                "Water Flow Rate (GPM)": "155.1",
                "Power Input (kW)": "18.34 KwH",
                "xPosition": "180",
                "yPosition": "320"
            ],
            imagePath: "AHU_2-5"
        ),
        
        //FAN
        sampleEquipment(
            assetID: "F1-1",
            assetName: "FAN",
            assetLocation: "GF - Toilet Wanita",
            assetSpecification: [
                "Tipe Unit": "ILC/ CFD",
                "Kapasitas(Cfm)": "1300",
                "Kapasitas (Kw)": "1.2",
                "xPosition": "260",
                "yPosition": "350"
            ]
        ),
        sampleEquipment(
            assetID: "F1-3",
            assetName: "FAN",
            assetLocation: "GF - Toilat Karyawan",
            assetSpecification: [
                "Tipe Unit": "ILC/ CFD",
                "Kapasitas(Cfm)": "1000",
                "Kapasitas (Kw)": "1.2",
                "xPosition": "100",
                "yPosition": "120"
                
            ]
        ),
        sampleEquipment(
            assetID: "F1-5",
            assetName: "FAN",
            assetLocation: "GF - ME",
            assetSpecification: [
                "Tipe Unit": "Axial/ TFA",
                "Kapasitas(Cfm)": "1900",
                "Kapasitas (Kw)": "1.5",
                "xPosition": "90",
                "yPosition": "140"
            ]
        ),
        sampleEquipment(
            assetID: "FFA1- ",
            assetName: "FAN",
            assetLocation: "GF - Ferragamo (Unit 31)",
            assetSpecification: [
                "Tipe Unit": "Axial/ TFA",
                "Kapasitas(Cfm)": "3200",
                "Kapasitas (Kw)": "1.5",
                "xPosition": "100",
                "yPosition": "40"
            ]
        ),
        sampleEquipment(
            assetID: "FFA1-3",
            assetName: "FAN",
            assetLocation: "GF - Sebelah AHU Twin Timur",
            assetSpecification: [
                "Tipe Unit": "Axial/ TFA",
                "Kapasitas(Cfm)": "11600",
                "Kapasitas (Kw)": "5.5",
                "xPosition": "40",
                "yPosition": "100"
            ]
        ),
        
        //AC
        sampleEquipment(
            assetID: "CS-D50DBH8",
            assetName: "AC SPLIT",
            assetLocation: "LG - Tenant Bally",
            assetSpecification: [
                "Merk": "Panasonic",
                "Kapasitas": "48000 BTU/h / 14.000 W",
                "Daya (Watt)": "140",
                "Voltage": "3 Phase 380 - 415 V 50 Hz",
                "xPosition": "150",
                "yPosition": "50"
            ]
        ),
        sampleEquipment(
            assetID: "ARNU96GB8A1",
            assetName: "AC SPLIT",
            assetLocation: "LG - Koridor Dynasti",
            assetSpecification: [
                "Merk": "LG",
                "Kapasitas": "28000 w / 95900 BTU / h",
                "Daya (Watt)": "800",
                "Voltage": "1 Phase 220 - 240 V 50 Hz",
                "xPosition": "180",
                "yPosition": "70"
            ]
        ),
        sampleEquipment(
            assetID: "ARNU96GB8A2",
            assetName: "AC SPLIT",
            assetLocation: "LG - Depan Dynasti Dynasti",
            assetSpecification: [
                "Merk": "LG",
                "Kapasitas": "28000 w / 95900 BTU / h",
                "Daya (Watt)": "800",
                "Voltage": "1 Phase 220 - 240 V 50 Hz",
                "xPosition": "70",
                "yPosition": "200"
            ]
        ),
        
        //LIFT
        sampleEquipment(
            assetID: "Lift 1",
            assetName: "Lift 1 Passenger Elevator (Gearless)",
            assetLocation: "ALL FLOOR",
            assetSpecification: [
                "Merk": "Hyundai",
                "Capacity": "17 Person / 1150KGs / 90 mpm",
                "Service floor": "Front: 7, Rear: NIL, Service Floor: 7 lantai 6 stop = LG, B1, 1, 2, 3, 4",
                "xPosition": "50",
                "yPosition": "50"
            ]
        ),
        sampleEquipment(
            assetID: "Lift 2 & 3",
            assetName: "Lift 2 & 3 Passenger Elevator (Gearless)",
            assetLocation: "ALL FLOOR",
            assetSpecification: [
                "Merk": "Hyundai",
                "Capacity": "20 Person / 1350KGs / 90 mpm",
                "Service floor": "Front: 7, Rear: NIL, Service Floor: 7 lantai 7 stop = LG, G, 1, 2, 3, 4, 5",
                "xPosition": "60",
                "yPosition": "120"
            ]
        )
    ]
    
    func updateAssetName(for id: String, newName: String) {
            if let index = equipments.firstIndex(where: { $0.assetID == id }) {
                equipments[index].assetName = newName
            }
        }
}


