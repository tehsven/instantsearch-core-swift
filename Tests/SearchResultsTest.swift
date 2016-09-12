//
//  Copyright (c) 2016 Algolia
//  http://www.algolia.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import AlgoliaSearch
@testable import AlgoliaSearchHelper
import XCTest

class SearchResultsTest: XCTestCase {
    
    var json: [String: AnyObject]!

    override func setUp() {
        // Pre-fill JSON with mandatory fields.
        json = [
            "hits": [],
            "nbHits": 0,
            "processingTimeMS": 66,
            "query": "",
            "params": ""
        ]
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Mandatory fields

    func testHits() {
        // Missing value.
        json.removeValue(forKey: "hits")
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Missing value.
        json["hits"] = 123 as AnyObject?
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Nominal case:
        json["hits"] = [
            ["abc": 123],
            ["def": 456]
        ]
        guard let results = try? SearchResults(content: json, disjunctiveFacets: []) else {
            XCTFail("Failed to construct results")
            return
        }
        XCTAssertEqual(2, results.hits.count)
    }
    
    func testNbHits() {
        // Missing value.
        json.removeValue(forKey: "nbHits")
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Mistyped value.
        json["nbHits"] = "XXX" as AnyObject?
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Nominal case:
        json["nbHits"] = 666 as AnyObject?
        guard let results = try? SearchResults(content: json, disjunctiveFacets: []) else {
            XCTFail("Failed to construct results")
            return
        }
        XCTAssertEqual(666, results.nbHits)
    }

    func testProcessingTimeMS() {
        // Missing value.
        json.removeValue(forKey: "processingTimeMS")
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Mistyped value.
        json["processingTimeMS"] = "XXX" as AnyObject?
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Nominal case:
        json["processingTimeMS"] = 666 as AnyObject?
        guard let results = try? SearchResults(content: json, disjunctiveFacets: []) else {
            XCTFail("Failed to construct results")
            return
        }
        XCTAssertEqual(666, results.processingTimeMS)
    }
    
    func testQuery() {
        // Missing value.
        json.removeValue(forKey: "query")
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Mistyped value.
        json["query"] = 666 as AnyObject?
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Nominal case:
        json["query"] = "some text" as AnyObject?
        guard let results = try? SearchResults(content: json, disjunctiveFacets: []) else {
            XCTFail("Failed to construct results")
            return
        }
        XCTAssertEqual("some text", results.query)
    }

    func testParams() {
        // Missing value.
        json.removeValue(forKey: "params")
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Mistyped value.
        json["params"] = 666 as AnyObject?
        XCTAssertNil(try? SearchResults(content: json, disjunctiveFacets: []))
        
        // Nominal case:
        json["params"] = "query=some%20text&facets=%5B%22abc%22,%22def%22%5D" as AnyObject?
        guard let results = try? SearchResults(content: json, disjunctiveFacets: []) else {
            XCTFail("Failed to construct results")
            return
        }
        XCTAssertEqual("some text", results.params.query)
        XCTAssertNotNil(results.params.facets)
        XCTAssertEqual(["abc", "def"], results.params.facets!)
    }
    
    // MARK: - Optional fields
    
    func testPage() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.page)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["page"] = "XXX" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.page)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["page"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(666, results.page)
        } else {
            XCTFail("Failed to construct results")
        }
    }
    
    func testNbPages() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.nbPages)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["nbPages"] = "XXX" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.nbPages)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["nbPages"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(666, results.nbPages)
        } else {
            XCTFail("Failed to construct results")
        }
    }

    func testHitsPerPage() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.hitsPerPage)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["hitsPerPage"] = "XXX" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.hitsPerPage)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["hitsPerPage"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(666, results.hitsPerPage)
        } else {
            XCTFail("Failed to construct results")
        }
    }

    func testExhaustiveFacetsCount() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(false, results.exhaustiveFacetsCount)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["exhaustiveFacetsCount"] = "XXX" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(false, results.exhaustiveFacetsCount)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["exhaustiveFacetsCount"] = true as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(true, results.exhaustiveFacetsCount)
        } else {
            XCTFail("Failed to construct results")
        }
    }

    func testMessage() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.message)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["message"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.message)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["message"] = "You've been warned" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual("You've been warned", results.message)
        } else {
            XCTFail("Failed to construct results")
        }
    }
    
    func testQueryAfterRemoval() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.queryAfterRemoval)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["queryAfterRemoval"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.queryAfterRemoval)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["queryAfterRemoval"] = "some text" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual("some text", results.queryAfterRemoval)
        } else {
            XCTFail("Failed to construct results")
        }
    }

    func testAroundLatLng() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.aroundLatLng)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["aroundLatLng"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.aroundLatLng)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }

        // Ill-formatted value.
        json["aroundLatLng"] = "123.456XYZ" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.aroundLatLng)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }

        // Nominal case:
        json["aroundLatLng"] = "12.34,45.67" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(LatLng(lat: 12.34, lng: 45.67), results.aroundLatLng)
        } else {
            XCTFail("Failed to construct results")
        }
    }

    func testAutomaticRadius() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.automaticRadius)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        // WARNING: This field is returned as a string by the API!
        json["automaticRadius"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(0, results.automaticRadius)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        // WARNING: This field is returned as a string by the API!
        json["automaticRadius"] = "666" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(666, results.automaticRadius)
        } else {
            XCTFail("Failed to construct results")
        }
    }

    func testServerUsed() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.serverUsed)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["serverUsed"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.serverUsed)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["serverUsed"] = "host.com" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual("host.com", results.serverUsed)
        } else {
            XCTFail("Failed to construct results")
        }
    }
    

    func testParsedQuery() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.parsedQuery)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["parsedQuery"] = 666 as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.parsedQuery)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["parsedQuery"] = "some text" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual("some text", results.parsedQuery)
        } else {
            XCTFail("Failed to construct results")
        }
    }
    
    func testTimeoutCounts() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(false, results.timeoutCounts)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["timeoutCounts"] = "XXX" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(false, results.timeoutCounts)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["timeoutCounts"] = true as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(true, results.timeoutCounts)
        } else {
            XCTFail("Failed to construct results")
        }
    }
    
    func testTimeoutHits() {
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(false, results.timeoutHits)
        } else {
            XCTFail("Absent optional value should not cause an error")
        }
        
        // Mistyped value.
        json["timeoutHits"] = "XXX" as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(false, results.timeoutHits)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        json["timeoutHits"] = true as AnyObject?
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual(true, results.timeoutHits)
        } else {
            XCTFail("Failed to construct results")
        }
    }
    
    func testFacets() {
        json["params"] = "facets=%5B%22abc%22,%22def%22,%22jkl%22%5D" as AnyObject?
        json["facets"] = [
            "abc": 666,
            "def": [
                "one": 1,
                "two": 2
            ]
        ]
        
        // Mistyped value, but listed in query: should return an empty array.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual([], results.facets("abc")!)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Missing value: optional.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.facets("xyz"))
        } else {
            XCTFail("Absent optional value should not cause an error")
        }

        // Missing facet in results, but listed in query: should return an empty array.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertEqual([], results.facets("jkl")!)
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            if let facetValues = results.facets("def") {
                XCTAssertEqual(2, facetValues.count)
            } else {
                XCTFail("Should have values for facet `def`")
            }
        } else {
            XCTFail("Failed to construct results")
        }
    }

    func testFacetStats() {
        json["params"] = "facets=%5B%22abc%22,%22def%22,%22jkl%22%5D" as AnyObject?
        json["facets_stats"] = [
            "abc": [
                "min": 1,
                "avg": 5,
                "max": 10,
                "sum": 66
            ]
        ]
        
        // Missing value.
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            XCTAssertNil(results.facetStats("xyz"))
        } else {
            XCTFail("Invalid optional value should not cause an error")
        }
        
        // Nominal case:
        if let results = try? SearchResults(content: json, disjunctiveFacets: []) {
            if let stats = results.facetStats("abc") {
                XCTAssertEqual(1, stats.min)
                XCTAssertEqual(5, stats.avg)
                XCTAssertEqual(10, stats.max)
                XCTAssertEqual(66, stats.sum)
            } else {
                XCTFail("Should have stats for facet `abc`")
            }
        } else {
            XCTFail("Failed to construct results")
        }
    }
}
