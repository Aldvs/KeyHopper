//
//  StorageManager.swift
//  KeyHopper
//
//  Created by admin on 12.05.2022.
//

import Foundation

class CryptoManager {
    
    static var shared = CryptoManager()
    
//    var openText = "1122334455667700ffeeddccbbaa9988"

    //MARK: - Основные функции

    func encryptionFunc(block openText: String, master key: String) -> String {
        
        let block = stringToBytes(for: openText)
        prepareKeys(master: key)
        let encryptedBlock = kuznechikEncryption(block: block)
        let resultString = getString(for: encryptedBlock)
        
        return resultString
    }

    func decryptionFunc(entireText openText: String, master key: String) -> String {
        prepareKeys(master: key)
        let tempBlock = stringToBytes(for: openText)
        let decryptedBlock = kuznechikDencryption(block: tempBlock)
        let resultString = getString(for: decryptedBlock)
        
        return resultString
    }

    func prepareKeys(master key: String) {
        let ourStringFirstKeys = getStringPairOfKeys(key: key)
        let firstPairOfKeys = getFirstPairOfKeys(for: ourStringFirstKeys)
        expandKeys(with: firstPairOfKeys[0], and: firstPairOfKeys[1])

    }
    
    //MARK: - АЛГОРИТМ ШИФРОВАНИЯ

    //значения для нелинейного преобразования множества двоичных векторов (преобразование S)
    let pi: [UInt8] = [
        0xFC, 0xEE, 0xDD, 0x11, 0xCF, 0x6E, 0x31, 0x16,
        0xFB, 0xC4, 0xFA, 0xDA, 0x23, 0xC5, 0x04, 0x4D,
        0xE9, 0x77, 0xF0, 0xDB, 0x93, 0x2E, 0x99, 0xBA,
        0x17, 0x36, 0xF1, 0xBB, 0x14, 0xCD, 0x5F, 0xC1,
        0xF9, 0x18, 0x65, 0x5A, 0xE2, 0x5C, 0xEF, 0x21,
        0x81, 0x1C, 0x3C, 0x42, 0x8B, 0x01, 0x8E, 0x4F,
        0x05, 0x84, 0x02, 0xAE, 0xE3, 0x6A, 0x8F, 0xA0,
        0x06, 0x0B, 0xED, 0x98, 0x7F, 0xD4, 0xD3, 0x1F,
        0xEB, 0x34, 0x2C, 0x51, 0xEA, 0xC8, 0x48, 0xAB,
        0xF2, 0x2A, 0x68, 0xA2, 0xFD, 0x3A, 0xCE, 0xCC,
        0xB5, 0x70, 0x0E, 0x56, 0x08, 0x0C, 0x76, 0x12,
        0xBF, 0x72, 0x13, 0x47, 0x9C, 0xB7, 0x5D, 0x87,
        0x15, 0xA1, 0x96, 0x29, 0x10, 0x7B, 0x9A, 0xC7,
        0xF3, 0x91, 0x78, 0x6F, 0x9D, 0x9E, 0xB2, 0xB1,
        0x32, 0x75, 0x19, 0x3D, 0xFF, 0x35, 0x8A, 0x7E,
        0x6D, 0x54, 0xC6, 0x80, 0xC3, 0xBD, 0x0D, 0x57,
        0xDF, 0xF5, 0x24, 0xA9, 0x3E, 0xA8, 0x43, 0xC9,
        0xD7, 0x79, 0xD6, 0xF6, 0x7C, 0x22, 0xB9, 0x03,
        0xE0, 0x0F, 0xEC, 0xDE, 0x7A, 0x94, 0xB0, 0xBC,
        0xDC, 0xE8, 0x28, 0x50, 0x4E, 0x33, 0x0A, 0x4A,
        0xA7, 0x97, 0x60, 0x73, 0x1E, 0x00, 0x62, 0x44,
        0x1A, 0xB8, 0x38, 0x82, 0x64, 0x9F, 0x26, 0x41,
        0xAD, 0x45, 0x46, 0x92, 0x27, 0x5E, 0x55, 0x2F,
        0x8C, 0xA3, 0xA5, 0x7D, 0x69, 0xD5, 0x95, 0x3B,
        0x07, 0x58, 0xB3, 0x40, 0x86, 0xAC, 0x1D, 0xF7,
        0x30, 0x37, 0x6B, 0xE4, 0x88, 0xD9, 0xE7, 0x89,
        0xE1, 0x1B, 0x83, 0x49, 0x4C, 0x3F, 0xF8, 0xFE,
        0x8D, 0x53, 0xAA, 0x90, 0xCA, 0xD8, 0x85, 0x61,
        0x20, 0x71, 0x67, 0xA4, 0x2D, 0x2B, 0x09, 0x5B,
        0xCB, 0x9B, 0x25, 0xD0, 0xBE, 0xE5, 0x6C, 0x52,
        0x59, 0xA6, 0x74, 0xD2, 0xE6, 0xF4, 0xB4, 0xC0,
        0xD1, 0x66, 0xAF, 0xC2, 0x39, 0x4B, 0x63, 0xB6
    ]

    // значения для обратного нелинейного преобразования множества двоичных векторов (обратное преобразование S)

    let reversePi: [UInt8] = [
        0xA5, 0x2D, 0x32, 0x8F, 0x0E, 0x30, 0x38, 0xC0,
        0x54, 0xE6, 0x9E, 0x39, 0x55, 0x7E, 0x52, 0x91,
        0x64, 0x03, 0x57, 0x5A, 0x1C, 0x60, 0x07, 0x18,
        0x21, 0x72, 0xA8, 0xD1, 0x29, 0xC6, 0xA4, 0x3F,
        0xE0, 0x27, 0x8D, 0x0C, 0x82, 0xEA, 0xAE, 0xB4,
        0x9A, 0x63, 0x49, 0xE5, 0x42, 0xE4, 0x15, 0xB7,
        0xC8, 0x06, 0x70, 0x9D, 0x41, 0x75, 0x19, 0xC9,
        0xAA, 0xFC, 0x4D, 0xBF, 0x2A, 0x73, 0x84, 0xD5,
        0xC3, 0xAF, 0x2B, 0x86, 0xA7, 0xB1, 0xB2, 0x5B,
        0x46, 0xD3, 0x9F, 0xFD, 0xD4, 0x0F, 0x9C, 0x2F,
        0x9B, 0x43, 0xEF, 0xD9, 0x79, 0xB6, 0x53, 0x7F,
        0xC1, 0xF0, 0x23, 0xE7, 0x25, 0x5E, 0xB5, 0x1E,
        0xA2, 0xDF, 0xA6, 0xFE, 0xAC, 0x22, 0xF9, 0xE2,
        0x4A, 0xBC, 0x35, 0xCA, 0xEE, 0x78, 0x05, 0x6B,
        0x51, 0xE1, 0x59, 0xA3, 0xF2, 0x71, 0x56, 0x11,
        0x6A, 0x89, 0x94, 0x65, 0x8C, 0xBB, 0x77, 0x3C,
        0x7B, 0x28, 0xAB, 0xD2, 0x31, 0xDE, 0xC4, 0x5F,
        0xCC, 0xCF, 0x76, 0x2C, 0xB8, 0xD8, 0x2E, 0x36,
        0xDB, 0x69, 0xB3, 0x14, 0x95, 0xBE, 0x62, 0xA1,
        0x3B, 0x16, 0x66, 0xE9, 0x5C, 0x6C, 0x6D, 0xAD,
        0x37, 0x61, 0x4B, 0xB9, 0xE3, 0xBA, 0xF1, 0xA0,
        0x85, 0x83, 0xDA, 0x47, 0xC5, 0xB0, 0x33, 0xFA,
        0x96, 0x6F, 0x6E, 0xC2, 0xF6, 0x50, 0xFF, 0x5D,
        0xA9, 0x8E, 0x17, 0x1B, 0x97, 0x7D, 0xEC, 0x58,
        0xF7, 0x1F, 0xFB, 0x7C, 0x09, 0x0D, 0x7A, 0x67,
        0x45, 0x87, 0xDC, 0xE8, 0x4F, 0x1D, 0x4E, 0x04,
        0xEB, 0xF8, 0xF3, 0x3E, 0x3D, 0xBD, 0x8A, 0x88,
        0xDD, 0xCD, 0x0B, 0x13, 0x98, 0x02, 0x93, 0x80,
        0x90, 0xD0, 0x24, 0x34, 0xCB, 0xED, 0xF4, 0xCE,
        0x99, 0x10, 0x44, 0x40, 0x92, 0x3A, 0x01, 0x26,
        0x12, 0x1A, 0x48, 0x68, 0xF5, 0x81, 0x8B, 0xC7,
        0xD6, 0x20, 0x0A, 0x08, 0x00, 0x4C, 0xD7, 0x74
    ]

    //L-вектор для реализации R-преобразования

    var lVector: [UInt8] = [
        148, 32, 133, 16, 194, 192, 1, 251,
        1, 192, 194, 16, 133, 32, 148, 1
    ]

    // массив для хранения итерационных констант С (32) 16 байт каждая
    var iterC: [[UInt8]] = Array(
        repeating: Array(repeating: UInt8(0x00), count: 16),
        count: 32
    )
    // массив для хранения ключей шифрования K (10) 64 бита
    var iterK: [[UInt8]] = Array(
        repeating: Array(repeating: UInt8(0x00), count: 64),
        count: 10
    )
    //ФУНКЦИЯ XOR
    func getXOR(from firstVect: [UInt8], and secondVect: [UInt8]) -> [UInt8] {
        var result: [UInt8] = []
        for i in 0..<16 {
            result.append(firstVect[i] ^ secondVect[i])
        }
        return result
    }

    //ФУНКЦИЯ S ПРЕОБРАЗОВАНИЯ
    func getS(from inData: [UInt8]) -> [UInt8] {
        var outData: [UInt8] = []
        for i in 0..<16 {
            outData.append(pi[Int(inData[i])])
        }
        return outData
    }

    //ФУНКЦИЯ ОБРАТНОГО S ПРЕОБРАЗОВАНИЯ
    func getReverseS(from inData: [UInt8]) -> [UInt8] {
        var outData: [UInt8] = []
        for i in 0..<16 {
            outData.append(reversePi[Int(inData[i])])
        }
        return outData
    }

    //ФУНКЦИЯ УМНОЖЕНИЕ В ПОЛЕ ГАЛУА

    // & - ПОБИТОВОЕ И
    // ^ - ПОБИТОВОЕ ИЛИ XOR

    func multiplicateGaluaField(from a: UInt8, and b: UInt8) -> UInt8 {
        var c: UInt8 = 0

        var tempA = a
        var tempB = b

        repeat {
            if ( tempB & 1 ) != 0 {
                c ^= tempA
            }
            if (tempA & 0x80) != 0 {
                tempA = (tempA << 1) ^ 0xC3
            } else {
                tempA <<= 1
            }
            tempB >>= 1
        } while (tempA != 0) && (tempB != 0)
        return c
    }

    //ПРЕОБРАЗОВАНИЕ R (умножение + сдвиг)
    func getTransformationR(for state: [UInt8]) -> [UInt8] {

        var aZero: UInt8 = 0
        var intern: [UInt8] = Array(repeating: 0x00, count: 16)

        for i in 0..<16 {
            
            if i == 15 {
                intern[0] = state[i]
            } else {
                intern[i+1] = state[i] //ДВИГАЕМ БАЙТЫ В СТОРОНУ МЛАДШЕГО РАЗРЯДА
            }

            aZero ^= multiplicateGaluaField(from: state[i], and: lVector[i])
            

        }
        
        //ПИШЕМ В ПОСЛЕДНИЙ БАЙТ РЕЗУЛЬТАТ СЛОЖЕНИЯ
        intern[0] = aZero
    //    print(intern)
        return intern
    }


    //ПРЕОБРАЗОВАНИЕ L
    func getTransformationL(for inData: [UInt8]) -> [UInt8] {
        var outData: [UInt8] = Array(repeating: 0x00, count: inData.count)
        var intern = inData
        for _ in 0..<15 {
            intern = getTransformationR(for: intern)
        }
        outData = intern
        return outData
    }
    func getTransformationLForFN(for inData: [UInt8]) -> [UInt8] {
        var outData: [UInt8] = Array(repeating: 0x00, count: inData.count)
        var intern = inData
        for _ in 0..<16 {
            intern = getTransformationR(for: intern)
        }
        outData = intern
        return outData
    }

    // ОБРАТНОЕ ПРЕОБРАЗОВАНИЕ R
    func getReverseR(for state: [UInt8]) -> [UInt8] {
        var i = 15
        var aLast: UInt8 = state[0]
        var intern:  [UInt8] = Array(repeating: 0x00, count: 16)
        repeat {
            
            intern[i-1] = state[i]
            aLast ^= multiplicateGaluaField(from: intern[i-1], and: lVector[i-1])
            i -= 1
        } while i != 0
        
        intern[15] = aLast
        return intern
    }


    //ОБРАТНОЕ ПРЕОБРАЗОВАНИЕ L
    func getReverseL(for inData: [UInt8]) -> [UInt8] {
        var outData:  [UInt8] = Array(repeating: 0x00, count: inData.count)
        var intern: [UInt8] = []
        intern = inData
        for _ in 0..<16 {
            intern = getReverseR(for: intern)
        }
        outData = intern
        return outData
    }

    //MARK: - РАЗВЕРТКА КЛЮЧЕЙ ФУНКЦИИ

    //ФУНКЦИЯ РАСЧЕТА КОНСТАНТ

    func getIterativeConstants() {
        
        var iterativeNumbers = Array(
            repeating: Array(repeating: UInt8(0x00), count: 16),
            count: 32
        ) //номер итерации от 1 до 32
        
    //    print(iterativeNumbers)
        
        for i in 0..<32 {
            for j in 0..<16 {
                iterativeNumbers[i][j] = 0
            }
            iterativeNumbers[i][0] = UInt8(i + 1)
        }
        
        for i in 0..<32 {
            iterC[i] = getTransformationL(for: iterativeNumbers[i]) //ДЕЛАЕМ ПРЕОБРАЗОВАНИЕ L для каждого элемента массива
        }
        
//    //    print(iterativeNumbers)
//        print("ITERATIVE CONSTANTS ____________________________")
//        for const in iterC {
//            print("\(const)")
//        }
//    //    print(iterC)
//        print("ITERATIVE CONSTANTS ____________________________")
    }

    //функция, выполняющая преобразования ячейки Фейстеля
    func getFeistelNetwork(keyOne firstKey: [UInt8],
                           keyTwo secondKey: [UInt8],
                           withIterC iterConst: [UInt8] ) -> [[UInt8]] {
        
    //    print("First key: \(firstKey)")
    //    print("Second key: \(secondKey)")
    //    print("Iter const: \(iterConst)")
        
        var inter: [UInt8] = []
        
        let outKeyTwo = firstKey

        inter = getXOR(from: firstKey, and: iterConst)
    //    print("Inter after XOR: \(inter)")
        inter = getS(from: inter)
    //    print("Inter after S: \(inter)")
        inter = getTransformationLForFN(for: inter)
    //    print("Inter after L: \(inter)")
        
        let outKeyOne = getXOR(from: inter, and: secondKey)
    //    print("Out key #1: \(outKeyOne)")
    //    print("Out key #2: \(outKeyTwo)")

        var key = Array(
            repeating: Array(repeating: UInt8(0x00), count: 16),
            count: 2)
        key[0] = outKeyOne
        key[1] = outKeyTwo
        return key
    }

    // функция расчета раундовых ключей

    func expandKeys(with keyOne: [UInt8], and keyTwo: [UInt8]) {
        //предыдущая пара ключей
        var iter12 = Array(
            repeating: Array(repeating: UInt8(0x00), count: 16),
            count: 2)
        //текущая пара ключей
        var iter34 = Array(
            repeating: Array(repeating: UInt8(0x00), count: 16),
            count: 2)
        
        getIterativeConstants() //вычисляем итерационные константы
        
        //Первые два итерационных ключа равны паре мастер ключа
        iterK[0] = keyOne
        iterK[1] = keyTwo
        
        iter12[0] = keyOne
        iter12[1] = keyTwo
        
    //    print("Keys in expand func")
    //    print(iterK[0])
    //    print(iterK[1])
        
        for i in 0..<4 {
            iter34 = getFeistelNetwork(keyOne: iter12[0], keyTwo: iter12[1], withIterC: iterC[0 + 8 * i])
            iter12 = getFeistelNetwork(keyOne: iter34[0], keyTwo: iter34[1], withIterC: iterC[1 + 8 * i])
            iter34 = getFeistelNetwork(keyOne: iter12[0], keyTwo: iter12[1], withIterC: iterC[2 + 8 * i])
            iter12 = getFeistelNetwork(keyOne: iter34[0], keyTwo: iter34[1], withIterC: iterC[3 + 8 * i])
            iter34 = getFeistelNetwork(keyOne: iter12[0], keyTwo: iter12[1], withIterC: iterC[4 + 8 * i])
            iter12 = getFeistelNetwork(keyOne: iter34[0], keyTwo: iter34[1], withIterC: iterC[5 + 8 * i])
            iter34 = getFeistelNetwork(keyOne: iter12[0], keyTwo: iter12[1], withIterC: iterC[6 + 8 * i])
            iter12 = getFeistelNetwork(keyOne: iter34[0], keyTwo: iter34[1], withIterC: iterC[7 + 8 * i])
            
            iterK[2 * i + 2] = iter12[0]
            iterK[2 * i + 3] = iter12[1]
        }
//        print("ITERATIVE KEYS ____________________________")
//        for key in iterK {
//            print("\(key)")
//        }
//    //    print(iterK)
//        print("ITERATIVE KEYS ____________________________")
    }
    //MARK: -

    // функция шифрования блока
    func kuznechikEncryption(block blk: [UInt8]) -> [UInt8] {
//        print("BLOCK")
//        print(blk)
        var outBlk: [UInt8] = []
        outBlk = blk
        
        for i in 0..<9 {
            
            outBlk = getXOR(from: iterK[i], and: outBlk)
            outBlk = getS(from: outBlk)
            outBlk = getTransformationLForFN(for: outBlk)
        }
        outBlk = getXOR(from: outBlk, and: iterK[9])
        return outBlk
    }

    //функция расшифрования блока
    func kuznechikDencryption(block blk: [UInt8]) -> [UInt8] {
        var outBlk: [UInt8] = []
        var i = 8
        outBlk = blk
        outBlk = getXOR(from: outBlk, and: iterK[9])
    //    print("OUTBLOCK after XORfirst: \(outBlk)")

        repeat {
            outBlk = getReverseL(for: outBlk)
    //        print("OUTBLOCK after RL: \(outBlk)")
            outBlk = getReverseS(from: outBlk)
    //        print("OUTBLOCK after RS: \(outBlk)")
            outBlk = getXOR(from: iterK[i], and: outBlk)
    //        print("OUTBLOCK after XOR: \(outBlk)")
            i -= 1
        } while i >= 0
        
            return outBlk
    }
    //MARK: - Convertation Functions

    func stringToArray(str txt: String) -> [String] {
        var openText = txt
        let startIndex = openText.startIndex
        var array: [String] = []
        var tempStr: String = ""
        var tempChar = ""

        repeat {
            for _ in 1...2 {
                tempChar = String(openText.remove(at: startIndex))
                tempStr += tempChar
            }
            array.append(tempStr)
            tempStr = ""
        } while !openText.isEmpty
        return array
    }

    func convertArrayToBytes(convert arr: [String]) -> [UInt8] {
        arr.map{UInt8($0, radix: 16)!}
    }

    //ФУНКЦИЯ ПОДГОТАВЛИВАЕТ ОТКРЫТЫЙ ТЕКСТ К ШИФРОВАНИЮ
    func stringToBytes(for stringToEncryption: String) -> [UInt8] {
        let arrayOfString = stringToArray(str: stringToEncryption)
        let arrayOfBytes = convertArrayToBytes(convert: arrayOfString)
        return arrayOfBytes
    }

    func bytesToString(for decryptedBytes: [UInt8]) -> [String] {
        var result: [String] = []
        var ultraResult: [String] = []
        result = decryptedBytes.map {String($0, radix: 16)}
        for str in result {
            if str.count != 2 {
                ultraResult.append("0\(str)")
            } else {
                ultraResult.append(str)
            }
        }
//        print("[STRING]\(ultraResult)")
        return ultraResult
    }

    func arrayToString(for decryptedString: [String]) -> String {
        var resultString = ""
        for stringByte in decryptedString {
            if stringByte == "0" {
                resultString += "\(stringByte)0"
            } else {
                resultString += stringByte
            }
        }
        return resultString
    }

    //ФУНКЦИЯ КОНВЕРТИРУЕТ МАССИВ БАЙТОВ ПОСЛЕ ДЕШИФРОВКИ В СТРОКУ
    func getString(for decryptedBytes: [UInt8]) -> String {
        let arrayOfString = bytesToString(for: decryptedBytes)
        let resultString = arrayToString(for: arrayOfString)
        return resultString
    }

    func getStringPairOfKeys(key fullKey: String) -> [String] {

        var pairOfKyes = [String]()

        let halfKey: Int = fullKey.count / 2
        let firstKey = fullKey[fullKey.startIndex..<fullKey.index(fullKey.startIndex, offsetBy: halfKey)]
        let secondKey = fullKey[fullKey.index(fullKey.startIndex, offsetBy: halfKey)..<fullKey.endIndex]

        pairOfKyes.append(String(firstKey))
        pairOfKyes.append(String(secondKey))

        return pairOfKyes
    }

    func getFirstPairOfKeys(for keys: [String]) -> [[UInt8]] {
        var twoKyes: [[UInt8]] = []
        var tempStringArray: [String] = []
        for partOfKey in keys {
            tempStringArray = stringToArray(str: partOfKey)
            twoKyes.append(convertArrayToBytes(convert: tempStringArray))
        }
        return twoKyes
    }
    private init() {}
}

