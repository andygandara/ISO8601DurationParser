//
//  ISO8601DurationParser.swift
//  
//
//  Created by Andy Gandara on 11/18/19.
//  https://github.com/andygandara
//

import Foundation

extension ISO8601DateFormatter {
    
    /// Takes an ISO 8601 duration string and adds duration to the date parameter. Returns an optional date result. For more information on
    /// ISO 8601 duration formatting, see [ISO 8601 Durations](https://en.wikipedia.org/wiki/ISO_8601#Durations).
    /// - Parameters:
    ///   - durationString: ISO 8601 duration string in the format of `PnYnMnDTnHnMnS` or `PnW`
    ///   - date: Date to which the duration will be added
    static func date(byAdding durationString: String, to date: Date) -> Date? {
        guard let components = durationComponents(from: durationString) else { return nil }
        return Calendar.current.date(byAdding: components, to: date)
    }
    
    /// Takes an ISO 8601 duration string and returns the corresponding date components. For more information on
    /// ISO 8601 duration formatting, see [ISO 8601 Durations](https://en.wikipedia.org/wiki/ISO_8601#Durations).
    /// - Parameter durationString: ISO 8601 duration string in the format of `PnYnMnDTnHnMnS` or `PnW`
    static func durationComponents(from durationString: String) -> DateComponents? {
        /// Validate `durationString` format
        let validationRegex = "^P(?:(\\d*)Y)?(?:(\\d*)M)?(?:(\\d*)W)?(?:(\\d*)D)?(?:T(?:(\\d*)H)?(?:(\\d*)M)?(?:(\\d*)S)?)?$"
        guard durationString.range(of: validationRegex, options: .regularExpression) != nil else { return nil }
        
        var dateComponents = DateComponents()

        /// `PnW` format
        if durationString.contains("W") {
            let weekValues = componentsForRegex(string: durationString, regexStrings: ["[0-9]{1,}W"])
            guard let weekValue = weekValues["W"] else { return nil }
            let weekValueDouble = Double(weekValue)
            dateComponents.day = Int(weekValueDouble * 7.0)
            return dateComponents
        }
        
        
        /// `PnYnMnDTnHnMnS` format
        // Gets PnYnMnD substring, then drops the P designator to return nYnMnD
        let periodString = durationString.contains("T") ?
            String(durationString[durationString.startIndex..<durationString.firstIndex(of: "T")!].dropFirst())
            : String(durationString.dropFirst())
        // Gets TnHnMnS substring, then drops the T designator to return nHnMnS
        let timeString = durationString.contains("T") ?
            String(durationString[durationString.firstIndex(of: "T")!..<durationString.endIndex].dropFirst())
            : ""
        
        // Parse period components
        let periodRegexes = ["[0-9]{1,}Y",
                             "[0-9]{1,}M",
                             "[0-9]{1,}D"]
        let periodComponentValues = componentsForRegex(string: periodString, regexStrings: periodRegexes)
        periodComponentValues.forEach { (key, value) in
            switch key {
            case "D": dateComponents.day = value
            case "M": dateComponents.month = value
            case "Y": dateComponents.year = value
            default: break
            }
        }

        // Parse time components
        let timeRegexes = ["[0-9]{1,}H",
                           "[0-9]{1,}M",
                           "[0-9]{1,}S"]
        let timeComponentValues = componentsForRegex(string: timeString, regexStrings: timeRegexes)
        timeComponentValues.forEach { (key, value) in
            switch key {
            case "S": dateComponents.second = value
            case "M": dateComponents.minute = value
            case "H": dateComponents.hour = value
            default: break
            }
        }

        return dateComponents
    }
    
    static private func componentsForRegex(string: String, regexStrings: [String]) -> Dictionary<String, Int> {
        guard string.count > 0 else { return [:] }
        
        var dictionary = [String: Int]()
        
        regexStrings.forEach { regexString in
            guard let regex = try? NSRegularExpression(pattern: regexString) else { return }
            let token = regex
                .matches(in: string, range: NSRange(string.startIndex..., in: string))
                .compactMap { String(string[Range($0.range, in: string)!]) }.first
            if var token = token {
                let key = String(token.removeLast())
                let value = Int(token)
                dictionary[key] = value
            }
        }
        
        return dictionary
    }
}
