////
////  EquipmentData.swift
////  MVP_CiputraWorld
////
////  Created by Niken Larasati on 27/08/25.
////
//
//import Foundation
//
////Data from CW
//class EquipmentStore: ObservableObject {
//    @Published var equipments: [Equipment] = [
//        
//        //AHU
//        Equipment(
//            assetID: "AHU.BS.2",
//            assetName: "AHU",
//            assetLocation: "LG - IKEA",
//            assetSpecification: [
//                "Tipe Unit": "CS 270",
//                "Cooling Load (Btu/h)": "678,000",
//                "Sensible Load (Btu/h)": "448,900",
//                "Supply Air Flow (CFM)": "19,550",
//                "Outdoor Air Flow (CFM)": "3,500",
//                "Water Flow Rate (GPM)": "135.7",
//                "Power Input (kW)": "6.34 KwH",
//                "xPosition": "120",
//                "yPosition": "80"
//            ],
//            imagePath: "AHU_1"
//        ),
//        Equipment(
//            assetID: "AHU.GF.5",
//            assetName: "AHU",
//            assetLocation: "GF - EXTERNAL EAST LOBBY",
//            assetSpecification: [
//                "Tipe Unit": "CS 217",
//                "Cooling Load (Btu/h)": "775,200",
//                "Sensible Load (Btu/h)": "513,700",
//                "Supply Air Flow (CFM)": "21,550",
//                "Outdoor Air Flow (CFM)": "3,950",
//                "Water Flow Rate (GPM)": "155.1",
//                "Power Input (kW)": "18.34 KwH",
//                "xPosition": "200",
//                "yPosition": "150"
//            ],
//            imagePath: "AHU_2-5"
//        ),
//        Equipment(
//            assetID: "AHU.GF.6",
//            assetName: "AHU",
//            assetLocation: "GF - EXTERNAL EAST LOBBY",
//            assetSpecification: [
//                "Tipe Unit": "CS 217",
//                "Cooling Load (Btu/h)": "775,200",
//                "Sensible Load (Btu/h)": "513,700",
//                "Supply Air Flow (CFM)": "21,550",
//                "Outdoor Air Flow (CFM)": "3,950",
//                "Water Flow Rate (GPM)": "155.1",
//                "Power Input (kW)": "18.34 KwH",
//                "xPosition": "250",
//                "yPosition": "250"
//            ],
//            imagePath: "AHU_2-5"
//        ),
//        Equipment(
//            assetID: "AHU.GF.4",
//            assetName: "AHU",
//            assetLocation: "GF - ZONE A",
//            assetSpecification: [
//                "Tipe Unit": "CS 217",
//                "Cooling Load (Btu/h)": "775,200",
//                "Sensible Load (Btu/h)": "513,700",
//                "Supply Air Flow (CFM)": "21,550",
//                "Outdoor Air Flow (CFM)": "3,950",
//                "Water Flow Rate (GPM)": "155.1",
//                "Power Input (kW)": "18.34 KwH",
//                "xPosition": "80",
//                "yPosition": "300"
//            ],
//            imagePath: "AHU_2-5"
//        ),
//        Equipment(
//            assetID: "AHU.GF.3",
//            assetName: "AHU",
//            assetLocation: "GF - ZONE A",
//            assetSpecification: [
//                "Tipe Unit": "CS 217",
//                "Cooling Load (Btu/h)": "775,200",
//                "Sensible Load (Btu/h)": "513,700",
//                "Supply Air Flow (CFM)": "21,550",
//                "Outdoor Air Flow (CFM)": "3,950",
//                "Water Flow Rate (GPM)": "155.1",
//                "Power Input (kW)": "18.34 KwH",
//                "xPosition": "180",
//                "yPosition": "320"
//            ],
//            imagePath: "AHU_2-5"
//        ),
//        
//        //FAN
//        Equipment(
//            assetID: "F1-1",
//            assetName: "FAN",
//            assetLocation: "GF - Toilet Wanita",
//            assetSpecification: [
//                "Tipe Unit": "ILC/ CFD",
//                "Kapasitas(Cfm)": "1300",
//                "Kapasitas (Kw)": "1.2",
//                "xPosition": "260",
//                "yPosition": "350"
//            ],
//            imagePath: "FAN_6-7"
//        ),
//        Equipment(
//            assetID: "F1-3",
//            assetName: "FAN",
//            assetLocation: "GF - Toilat Karyawan",
//            assetSpecification: [
//                "Tipe Unit": "ILC/ CFD",
//                "Kapasitas(Cfm)": "1000",
//                "Kapasitas (Kw)": "1.2",
//                "xPosition": "100",
//                "yPosition": "120"
//            ],
//            imagePath: "FAN_6-7"
//        ),
//        Equipment(
//            assetID: "F1-5",
//            assetName: "FAN",
//            assetLocation: "GF - ME",
//            assetSpecification: [
//                "Tipe Unit": "Axial/ TFA",
//                "Kapasitas(Cfm)": "1900",
//                "Kapasitas (Kw)": "1.5",
//                "xPosition": "90",
//                "yPosition": "140"
//            ],
//            imagePath: "FAN_8-10"
//        ),
//        Equipment(
//            assetID: "FFA1-1",
//            assetName: "FAN",
//            assetLocation: "GF - Ferragamo (Unit 31)",
//            assetSpecification: [
//                "Tipe Unit": "Axial/ TFA",
//                "Kapasitas(Cfm)": "3200",
//                "Kapasitas (Kw)": "1.5",
//                "xPosition": "100",
//                "yPosition": "40"
//            ],
//            imagePath: "FAN_8-10"
//        ),
//        Equipment(
//            assetID: "FFA1-3",
//            assetName: "FAN",
//            assetLocation: "GF - Sebelah AHU Twin Timur",
//            assetSpecification: [
//                "Tipe Unit": "Axial/ TFA",
//                "Kapasitas(Cfm)": "11600",
//                "Kapasitas (Kw)": "5.5",
//                "xPosition": "40",
//                "yPosition": "100"
//            ],
//            imagePath: "FAN_8-10"
//        ),
//        
//        //AC
//        Equipment(
//            assetID: "CS-D50DBH8",
//            assetName: "AC SPLIT",
//            assetLocation: "LG - Tenant Bally",
//            assetSpecification: [
//                "Merk": "Panasonic",
//                "Kapasitas": "48000 BTU/h / 14.000 W",
//                "Daya (Watt)": "140",
//                "Voltage": "3 Phase 380 - 415 V 50 Hz",
//                "xPosition": "150",
//                "yPosition": "50"
//            ],
//            imagePath: "AC_11"
//        ),
//        Equipment(
//            assetID: "ARNU96GB8A1",
//            assetName: "AC SPLIT",
//            assetLocation: "LG - Koridor Dynasti",
//            assetSpecification: [
//                "Merk": "LG",
//                "Kapasitas": "28000 w / 95900 BTU / h",
//                "Daya (Watt)": "800",
//                "Voltage": "1 Phase 220 - 240 V 50 Hz",
//                "xPosition": "180",
//                "yPosition": "70"
//            ],
//            imagePath: "AC_12-13"
//        ),
//        Equipment(
//            assetID: "ARNU96GB8A2",
//            assetName: "AC SPLIT",
//            assetLocation: "LG - Depan Dynasti Dynasti",
//            assetSpecification: [
//                "Merk": "LG",
//                "Kapasitas": "28000 w / 95900 BTU / h",
//                "Daya (Watt)": "800",
//                "Voltage": "1 Phase 220 - 240 V 50 Hz",
//                "xPosition": "70",
//                "yPosition": "200"
//            ],
//            imagePath: "AC_12-13"
//        ),
//        
//        //LIFT
//        Equipment(
//            assetID: "Lift-1",
//            assetName: "Lift 1 Passenger Elevator (Gearless)",
//            assetLocation: "ALL FLOOR",
//            assetSpecification: [
//                "Merk": "Hyundai",
//                "Capacity": "17 Person / 1150KGs / 90 mpm",
//                "Service floor": "Front: 7, Rear: NIL, Service Floor: 7 lantai 6 stop = LG, B1, 1, 2, 3, 4",
//                "xPosition": "320",
//                "yPosition": "330"
//            ],
//            imagePath: "LIFT_14"
//        ),
//        Equipment(
//            assetID: "Lift-2&3",
//            assetName: "Lift 2 & 3 Passenger Elevator (Gearless)",
//            assetLocation: "ALL FLOOR",
//            assetSpecification: [
//                "Merk": "Hyundai",
//                "Capacity": "20 Person / 1350KGs / 90 mpm",
//                "Service floor": "Front: 7, Rear: NIL, Service Floor: 7 lantai 7 stop = LG, G, 1, 2, 3, 4, 5",
//                "xPosition": "60",
//                "yPosition": "120"
//            ],
//            imagePath: "LIFT_14"
//        )
//    ]
//    
//    // CRUD Operations
//    func add(_ equipment: sampleEquipment) {
//        equipments.append(equipment)
//    }
//    
//    func update(_ equipment: sampleEquipment) {
//        if let index = equipments.firstIndex(where: { $0.assetID == equipment.assetID }) {
//            equipments[index] = equipment
//        }
//    }
//    
//    func remove(id: String) {
//        equipments.removeAll { $0.assetID == id }
//    }
//    
//    func updateImagePath(for assetID: String, newImagePath: String) {
//        if let index = equipments.firstIndex(where: { $0.assetID == assetID }) {
//            equipments[index].imagePath = newImagePath
//        }
//    }
//    
//    // Search functionality
//    func search(by keyword: String) -> [sampleEquipment] {
//        equipments.filter {
//            keyword.isEmpty ||
//            $0.assetName.localizedCaseInsensitiveContains(keyword) ||
//            $0.assetID.localizedCaseInsensitiveContains(keyword)
//        }
//    }
//    
//    // Filter by category
//    func filterByCategory(_ category: String?) -> [sampleEquipment] {
//        guard let category = category else { return equipments }
//        return equipments.filter { $0.equipmentType == category }
//    }
//}
//
//
