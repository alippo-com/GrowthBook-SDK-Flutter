const String gbTestCases = r'''
    {
      "evalCondition": [
        [
          "$not     - pass",
          {
            "$not": {
              "name": "hello"
            }
          },
          {
            "name": "world"
          },
          true
        ],
        [
    "$gt    /$lt     strings - fail $gt    ",
    {
      "word": {
        "$gt": "alphabet",
        "$lt": "zebra"
      }
    },
    {
      "word": "alphabet"
    },
    false
  ],
  [
    "$gt    /$lt     strings - fail $lt    ",
    {
      "word": {
        "$gt": "alphabet",
        "$lt": "zebra"
      }
    },
    {
      "word": "zebra"
    },
    false
  ],
  [
    "$gt    /$lt     strings - pass",
    {
      "word": {
        "$gt": "alphabet",
        "$lt": "zebra"
      }
    },
    {
      "word": "always"
    },
    true
  ],
  [
    "$gt    /$lt     strings - fail uppercase",
    {
      "word": {
        "$gt": "alphabet",
        "$lt": "zebra"
      }
    },
    {
      "word": "AZL"
    },
    false
  ],
        [
          "$not     - fail",
          {
            "$not": {
              "name": "hello"
            }
          },
          {
            "name": "hello"
          },
          false
        ],
        [
          "$and    /$or     - all true",
          {
            "$and": [
              {
                "father.age": {
                  "$gt": 65
                }
              },
              {
                "$or": [
                  {
                    "bday": {
                      "$regex": "-12-25$"
                    }
                  },
                  {
                    "name": "santa"
                  }
                ]
              }
            ]
          },
          {
            "name": "santa",
            "bday": "1980-12-25",
            "father": {
              "age": 70
            }
          },
          true
        ],
        [
          "$and    /$or     - first or true",
          {
            "$and": [
              {
                "father.age": {
                  "$gt": 65
                }
              },
              {
                "$or": [
                  {
                    "bday": {
                      "$regex": "-12-25$"
                    }
                  },
                  {
                    "name": "santa"
                  }
                ]
              }
            ]
          },
          {
            "name": "santa",
            "bday": "1980-12-20",
            "father": {
              "age": 70
            }
          },
          true
        ],
        [
          "$and    /$or     - second or true",
          {
            "$and": [
              {
                "father.age": {
                  "$gt": 65
                }
              },
              {
                "$or": [
                  {
                    "bday": {
                      "$regex": "-12-25$"
                    }
                  },
                  {
                    "name": "santa"
                  }
                ]
              }
            ]
          },
          {
            "name": "barbara",
            "bday": "1980-12-25",
            "father": {
              "age": 70
            }
          },
          true
        ],
        [
          "$and    /$or     - first and false",
          {
            "$and": [
              {
                "father.age": {
                  "$gt": 65
                }
              },
              {
                "$or": [
                  {
                    "bday": {
                      "$regex": "-12-25$"
                    }
                  },
                  {
                    "name": "santa"
                  }
                ]
              }
            ]
          },
          {
            "name": "santa",
            "bday": "1980-12-25",
            "father": {
              "age": 65
            }
          },
          false
        ],
        [
          "$and    /$or     - both or false",
          {
            "$and": [
              {
                "father.age": {
                  "$gt": 65
                }
              },
              {
                "$or": [
                  {
                    "bday": {
                      "$regex": "-12-25$"
                    }
                  },
                  {
                    "name": "santa"
                  }
                ]
              }
            ]
          },
          {
            "name": "barbara",
            "bday": "1980-11-25",
            "father": {
              "age": 70
            }
          },
          false
        ],
        [
          "$and    /$or     - both and false",
          {
            "$and": [
              {
                "father.age": {
                  "$gt": 65
                }
              },
              {
                "$or": [
                  {
                    "bday": {
                      "$regex": "-12-25$"
                    }
                  },
                  {
                    "name": "santa"
                  }
                ]
              }
            ]
          },
          {
            "name": "john smith",
            "bday": "1956-12-20",
            "father": {
              "age": 40
            }
          },
          false
        ],
        [
          "$exists     - false pass",
          {
            "pets.dog.name": {
              "$exists": false
            }
          },
          {
            "hello": "world"
          },
          true
        ],
        [
          "$exists     - false fail",
          {
            "pets.dog.name": {
              "$exists": false
            }
          },
          {
            "pets": {
              "dog": {
                "name": "fido"
              }
            }
          },
          false
        ],
        [
          "$exists     - true fail",
          {
            "pets.dog.name": {
              "$exists": true
            }
          },
          {
            "hello": "world"
          },
          false
        ],
        [
          "$exists     - true pass",
          {
            "pets.dog.name": {
              "$exists": true
            }
          },
          {
            "pets": {
              "dog": {
                "name": "fido"
              }
            }
          },
          true
        ],
        [
          "equals - multiple datatypes",
          {
            "str": "str",
            "num": 10,
            "flag": false
          },
          {
            "str": "str",
            "num": 10,
            "flag": false
          },
          true
        ],
        [
          "$in - pass",
          {
            "num": {
              "$in": [
                1,
                2,
                3
              ]
            }
          },
          {
            "num": 2
          },
          true
        ],
        [
          "$in - fail",
          {
            "num": {
              "$in": [
                1,
                2,
                3
              ]
            }
          },
          {
            "num": 4
          },
          false
        ],
        [
          "$nin     - pass",
          {
            "num": {
              "$nin": [
                1,
                2,
                3
              ]
            }
          },
          {
            "num": 4
          },
          true
        ],
        [
          "$nin     - fail",
          {
            "num": {
              "$nin": [
                1,
                2,
                3
              ]
            }
          },
          {
            "num": 2
          },
          false
        ],
        [
          "$elemMatch     - pass - flat arrays",
          {
            "nums": {
              "$elemMatch": {
                "$gt": 10
              }
            }
          },
          {
            "nums": [
              0,
              5,
              -20,
              15
            ]
          },
          true
        ],
        [
          "$elemMatch     - fail - flat arrays",
          {
            "nums": {
              "$elemMatch": {
                "$gt": 10
              }
            }
          },
          {
            "nums": [
              0,
              5,
              -20,
              8
            ]
          },
          false
        ],
        [
          "missing attribute - fail",
          {
            "pets.dog.name": {
              "$in": [
                "fido"
              ]
            }
          },
          {
            "hello": "world"
          },
          false
        ],
        [
          "empty $or     - pass",
          {
            "$or": [
              
            ]
          },
          {
            "hello": "world"
          },
          true
        ],
        [
          "empty $and     - pass",
          {
            "$and": [
              
            ]
          },
          {
            "hello": "world"
          },
          true
        ],
        [
          "empty - pass",
          {
            
          },
          {
            "hello": "world"
          },
          true
        ],
        [
          "$eq     - pass",
          {
            "occupation": {
              "$eq": "engineer"
            }
          },
          {
            "occupation": "engineer"
          },
          true
        ],
        [
          "$eq     - fail",
          {
            "occupation": {
              "$eq": "engineer"
            }
          },
          {
            "occupation": "civil engineer"
          },
          false
        ],
        [
          "$ne     - pass",
          {
            "level": {
              "$ne": "senior"
            }
          },
          {
            "level": "junior"
          },
          true
        ],
        [
          "$ne     - fail",
          {
            "level": {
              "$ne": "senior"
            }
          },
          {
            "level": "senior"
          },
          false
        ],
        [
          "$regex     - pass",
          {
            "userAgent": {
              "$regex": "(Mobile|Tablet)"
            }
          },
          {
            "userAgent": "Android Mobile Browser"
          },
          true
        ],
        [
          "$regex     - fail",
          {
            "userAgent": {
              "$regex": "(Mobile|Tablet)"
            }
          },
          {
            "userAgent": "Chrome Desktop Browser"
          },
          false
        ],
        [
          "$gt    /$lt     numbers - pass",
          {
            "age": {
              "$gt": 30,
              "$lt": 60
            }
          },
          {
            "age": 50
          },
          true
        ],
        [
          "$gt    /$lt     numbers - fail $lt    ",
          {
            "age": {
              "$gt": 30,
              "$lt": 60
            }
          },
          {
            "age": 60
          },
          false
        ],
        [
          "$gt    /$lt     numbers - fail $gt    ",
          {
            "age": {
              "$gt": 30,
              "$lt": 60
            }
          },
          {
            "age": 30
          },
          false
        ],
        [
          "$gte    /$lte     numbers - pass",
          {
            "age": {
              "$gte": 30,
              "$lte": 60
            }
          },
          {
            "age": 50
          },
          true
        ],
        [
          "$gte    /$lte     numbers - pass $gte    ",
          {
            "age": {
              "$gte": 30,
              "$lte": 60
            }
          },
          {
            "age": 30
          },
          true
        ],
        [
          "$gte    /$lte     numbers - pass $lte    ",
          {
            "age": {
              "$gte": 30,
              "$lte": 60
            }
          },
          {
            "age": 60
          },
          true
        ],
        [
          "$gte    /$lte     numbers - fail $lte    ",
          {
            "age": {
              "$gte": 30,
              "$lte": 60
            }
          },
          {
            "age": 61
          },
          false
        ],
        [
          "$gte    /$lte     numbers - fail $gte    ",
          {
            "age": {
              "$gt": 30,
              "$lt": 60
            }
          },
          {
            "age": 29
          },
          false
        ],
        [
          "$type     string - pass",
          {
            "a": {
              "$type": "string"
            }
          },
          {
            "a": "a"
          },
          true
        ],
        [
          "$type     string - fail",
          {
            "a": {
              "$type": "string"
            }
          },
          {
            "a": 1
          },
          false
        ],
        [
          "$type     null - pass",
          {
            "a": {
              "$type": "null"
            }
          },
          {
            "a": null
          },
          true
        ],
        [
          "$type     null - fail",
          {
            "a": {
              "$type": "null"
            }
          },
          {
            "a": 1
          },
          false
        ],
        [
          "$type     boolean - pass",
          {
            "a": {
              "$type": "boolean"
            }
          },
          {
            "a": false
          },
          true
        ],
        [
          "$type     boolean - fail",
          {
            "a": {
              "$type": "boolean"
            }
          },
          {
            "a": 1
          },
          false
        ],
        [
          "$type     number - pass",
          {
            "a": {
              "$type": "number"
            }
          },
          {
            "a": 1
          },
          true
        ],
        [
          "$type     number - fail",
          {
            "a": {
              "$type": "number"
            }
          },
          {
            "a": "a"
          },
          false
        ],
        [
          "$type     object - pass",
          {
            "a": {
              "$type": "object"
            }
          },
          {
            "a": {
              "a": "b"
            }
          },
          true
        ],
        [
          "$type     object - fail",
          {
            "a": {
              "$type": "object"
            }
          },
          {
            "a": 1
          },
          false
        ],
        [
          "$type     array - pass",
          {
            "a": {
              "$type": "array"
            }
          },
          {
            "a": [
              1,
              2
            ]
          },
          true
        ],
        [
          "$type     array - fail",
          {
            "a": {
              "$type": "array"
            }
          },
          {
            "a": 1
          },
          false
        ],
        [
          "unknown operator - pass",
          {
            "name": {
              "$regx": "hello"
            }
          },
          {
            "name": "hello"
          },
          false
        ],
        [
          "$regex     invalid - pass",
          {
            "name": {
              "$regex": "/???***[)"
            }
          },
          {
            "name": "hello"
          },
          false
        ],
        [
          "$regex     invalid - fail",
          {
            "name": {
              "$regex": "/???***[)"
            }
          },
          {
            "hello": "hello"
          },
          false
        ],
        [
          "$size     number - pass",
          {
            "tags": {
              "$size": 3
            }
          },
          {
            "tags": [
              "a",
              "b",
              "c"
            ]
          },
          true
        ],
        [
          "$size     number - fail small",
          {
            "tags": {
              "$size": 3
            }
          },
          {
            "tags": [
              "a",
              "b"
            ]
          },
          false
        ],
        [
          "$size     number - fail large",
          {
            "tags": {
              "$size": 3
            }
          },
          {
            "tags": [
              "a",
              "b",
              "c",
              "d"
            ]
          },
          false
        ],
        [
          "$size     number - fail not array",
          {
            "tags": {
              "$size": 3
            }
          },
          {
            "tags": "abc"
          },
          false
        ],
        [
          "$size     nested - pass",
          {
            "tags": {
              "$size": {
                "$gt": 2
              }
            }
          },
          {
            "tags": [
              0,
              1,
              2
            ]
          },
          true
        ],
        [
          "$size     nested - fail equal",
          {
            "tags": {
              "$size": {
                "$gt": 2
              }
            }
          },
          {
            "tags": [
              0,
              1
            ]
          },
          false
        ],
        [
          "$size     nested - fail less than",
          {
            "tags": {
              "$size": {
                "$gt": 2
              }
            }
          },
          {
            "tags": [
              0
            ]
          },
          false
        ],
        [
          "$elemMatch     nested - pass",
          {
            "hobbies": {
              "$elemMatch": {
                "name": {
                  "$regex": "^ping"
                }
              }
            }
          },
          {
            "hobbies": [
              {
                "name": "bowling"
              },
              {
                "name": "pingpong"
              },
              {
                "name": "tennis"
              }
            ]
          },
          true
        ],
        [
          "$elemMatch     nested - fail",
          {
            "hobbies": {
              "$elemMatch": {
                "name": {
                  "$regex": "^ping"
                }
              }
            }
          },
          {
            "hobbies": [
              {
                "name": "bowling"
              },
              {
                "name": "tennis"
              }
            ]
          },
          false
        ],
        [
          "$elemMatch     nested - fail not array",
          {
            "hobbies": {
              "$elemMatch": {
                "name": {
                  "$regex": "^ping"
                }
              }
            }
          },
          {
            "hobbies": "all"
          },
          false
        ],
        [
          "$not     - pass",
          {
            "name": {
              "$not": {
                "$regex": "^hello"
              }
            }
          },
          {
            "name": "world"
          },
          true
        ],
        [
          "$not     - fail",
          {
            "name": {
              "$not": {
                "$regex": "^hello"
              }
            }
          },
          {
            "name": "hello world"
          },
          false
        ],
        [
          "$all     - pass",
          {
            "tags": {
              "$all": [
                "one",
                "three"
              ]
            }
          },
          {
            "tags": [
              "one",
              "two",
              "three"
            ]
          },
          true
        ],
        [
          "$all     - fail",
          {
            "tags": {
              "$all": [
                "one",
                "three"
              ]
            }
          },
          {
            "tags": [
              "one",
              "two",
              "four"
            ]
          },
          false
        ],
        [
          "$all     - fail not array",
          {
            "tags": {
              "$all": [
                "one",
                "three"
              ]
            }
          },
          {
            "tags": "hello"
          },
          false
        ],
        [
          "$nor     - pass",
          {
            "$nor": [
              {
                "name": "john"
              },
              {
                "age": {
                  "$lt": 30
                }
              }
            ]
          },
          {
            "name": "jim",
            "age": 40
          },
          true
        ],
        [
          "$nor     - fail both",
          {
            "$nor": [
              {
                "name": "john"
              },
              {
                "age": {
                  "$lt": 30
                }
              }
            ]
          },
          {
            "name": "john",
            "age": 20
          },
          false
        ],
        [
          "$nor     - fail first",
          {
            "$nor": [
              {
                "name": "john"
              },
              {
                "age": {
                  "$lt": 30
                }
              }
            ]
          },
          {
            "name": "john",
            "age": 40
          },
          false
        ],
        [
          "$nor     - fail second",
          {
            "$nor": [
              {
                "name": "john"
              },
              {
                "age": {
                  "$lt": 30
                }
              }
            ]
          },
          {
            "name": "jim",
            "age": 20
          },
          false
        ],
        [
          "equals array - pass",
          {
            "tags": [
              "hello",
              "world"
            ]
          },
          {
            "tags": [
              "hello",
              "world"
            ]
          },
          true
        ],
        [
          "equals array - fail order",
          {
            "tags": [
              "hello",
              "world"
            ]
          },
          {
            "tags": [
              "world",
              "hello"
            ]
          },
          false
        ],
        [
          "equals array - fail missing item",
          {
            "tags": [
              "hello",
              "world"
            ]
          },
          {
            "tags": [
              "hello"
            ]
          },
          false
        ],
        [
          "equals array - fail extra item",
          {
            "tags": [
              "hello",
              "world"
            ]
          },
          {
            "tags": [
              "hello",
              "world",
              "foo"
            ]
          },
          false
        ],
        [
          "equals array - fail type mismatch",
          {
            "tags": [
              "hello",
              "world"
            ]
          },
          {
            "tags": "hello world"
          },
          false
        ],
        [
          "equals object - pass",
          {
            "tags": {
              "hello": "world"
            }
          },
          {
            "tags": {
              "hello": "world"
            }
          },
          true
        ],
        [
          "equals object - fail extra property",
          {
            "tags": {
              "hello": "world"
            }
          },
          {
            "tags": {
              "hello": "world",
              "yes": "please"
            }
          },
          false
        ],
        [
          "equals object - fail missing property",
          {
            "tags": {
              "hello": "world"
            }
          },
          {
            "tags": {
              
            }
          },
          false
        ],
        [
          "equals object - fail type mismatch",
          {
            "tags": {
              "hello": "world"
            }
          },
          {
            "tags": "hello world"
          },
          false
        ],
        [
          "$vgt/$vlt - pass - major",
          {
            "version": {
              "$vgt": "9.99.8",
              "$vlt": "11.0.1"
            }
          },
          {
            "version": "10.12.13"
          },
          true
        ],
        [
          "$vgt/$vlt - pass - minor",
          {
            "version": {
              "$vgt": "10.2.11",
              "$vlt": "10.20.11"
            }
          },
          {
            "version": "10.12.11"
          },
          true
        ],
        [
          "$vgt/$vlt - pass - patch",
          {
            "version": {
              "$vgt": "10.0.2",
              "$vlt": "10.0.20"
            }
          },
          {
            "version": "10.0.12"
          },
          true
        ],
        [
          "$vgt/$vlt - fail $vlt - major",
          {
            "version": {
              "$vgt": "30.0.0",
              "$vlt": "50.0.0"
            }
          },
          {
            "version": "60.0.0"
          },
          false
        ],
        [
          "$vgt/$vlt - fail $vlt - minor",
          {
            "version": {
              "$vgt": "10.30.0",
              "$vlt": "10.50.0"
            }
          },
          {
            "version": "10.60.0"
          },
          false
        ],
        [
          "$vgt/$vlt - fail $vlt - patch",
          {
            "version": {
              "$vgt": "10.2.30",
              "$vlt": "10.2.50"
            }
          },
          {
            "version": "10.2.60"
          },
          false
        ],
        [
          "$vgt/$vlt - fail $vgt - major",
          {
            "version": {
              "$vgt": "30.0.16",
              "$vlt": "50.0.16"
            }
          },
          {
            "version": "20.0.16"
          },
          false
        ],
        [
          "$vgt/$vlt - fail $vgt - minor",
          {
            "version": {
              "$vgt": "10.30.0",
              "$vlt": "10.50.0"
            }
          },
          {
            "version": "10.20.0"
          },
          false
        ],
        [
          "$vgt/$vlt - fail $vgt - patch",
          {
            "version": {
              "$vgt": "10.30.10",
              "$vlt": "10.30.20"
            }
          },
          {
            "version": "10.30.2"
          },
          false
        ],
        [
          "$vgte/$vlte - pass $vgte - major",
          {
            "version": {
              "$vgte": "30.1.2",
              "$vlte": "60.1.2"
            }
          },
          {
            "version": "30.1.2"
          },
          true
        ],
        [
          "$vgte/$vlte - pass $vgte - minor",
          {
            "version": {
              "$vgte": "5.30.2",
              "$vlte": "5.60.2"
            }
          },
          {
            "version": "5.30.2"
          },
          true
        ],
        [
          "$vgte/$vlte - pass $vgte - patch",
          {
            "version": {
              "$vgte": "5.10.30",
              "$vlte": "5.10.60"
            }
          },
          {
            "version": "5.10.30"
          },
          true
        ],
        [
          "$vgte/$vlte - pass $vlte - major",
          {
            "version": {
              "$vgte": "30.1.2",
              "$vlte": "60.1.2"
            }
          },
          {
            "version": "60.1.2"
          },
          true
        ],
        [
          "$vgte/$vlte - pass $vlte - minor",
          {
            "version": {
              "$vgte": "1.30.2",
              "$vlte": "1.60.2"
            }
          },
          {
            "version": "1.60.2"
          },
          true
        ],
        [
          "$vgte/$vlte - pass $vlte - patch",
          {
            "version": {
              "$vgte": "1.2.30",
              "$vlte": "1.2.60"
            }
          },
          {
            "version": "1.2.60"
          },
          true
        ],
        [
          "$vgte/$vlte - fail $vlte - major",
          {
            "version": {
              "$vgte": "30.1.2",
              "$vlte": "60.1.2"
            }
          },
          {
            "version": "61.1.2"
          },
          false
        ],
        [
          "$vgte/$vlte - fail $vgt - minor",
          {
            "version": {
              "$vgte": "30.1.2",
              "$vlte": "60.1.2"
            }
          },
          {
            "version": "29.1.2"
          },
          false
        ],
        [
          "$vgte/$vlte - fail $vgt - patch",
          {
            "version": {
              "$vgte": "1.2.30",
              "$vlte": "1.2.60"
            }
          },
          {
            "version": "1.2.29"
          },
          false
        ],
        [
          "$vgt/$vlt prerelease - fail $vgt",
          {
            "v": {
              "$vgt": "1.0.0-alpha",
              "$vlt": "1.0.0-beta"
            }
          },
          {
            "v": "1.0.0-alpha"
          },
          false
        ],
        [
          "$vgt/$vlt prerelease  w/ multiple fields - fail $vgt",
          {
            "v": {
              "$vgt": "1.0.0-alpha.2",
              "$vlt": "1.0.0-beta.1"
            }
          },
          {
            "v": "1.0.0-alpha.1"
          },
          false
        ],
        [
          "$vgt/$vlt prerelease - fail $vlt",
          {
            "v": {
              "$vgt": "1.0.0-alpha",
              "$vlt": "1.0.0-beta"
            }
          },
          {
            "v": "1.0.0-beta"
          },
          false
        ],
        [
          "$vgt/$vlt prerelease - pass",
          {
            "v": {
              "$vgt": "1.0.0-alpha",
              "$vlt": "1.0.0-beta"
            }
          },
          {
            "v": "1.0.0-alpha.10"
          },
          true
        ],
        [
          "$vgt/$vlt prerelease - fail uppercase",
          {
            "v": {
              "$vgt": "1.0.0-alpha",
              "$vlt": "1.0.0-beta"
            }
          },
          {
            "v": "1.0.0-ALPHA"
          },
          false
        ],
        [
          "$veq - pass",
          {
            "v": {
              "$veq": "1.2.3"
            }
          },
          {
            "v": "1.2.3"
          },
          true
        ],
        [
          "$veq - pass (with build)",
          {
            "v": {
              "$veq": "1.2.3"
            }
          },
          {
            "v": "1.2.3+build.abc.123"
          },
          true
        ],
        [
          "$vne - pass",
          {
            "v": {
              "$vne": "1.2.3"
            }
          },
          {
            "v": "2.2.3"
          },
          true
        ],
        [
          "$vne - pass (prerelease)",
          {
            "v": {
              "$vne": "1.2.3"
            }
          },
          {
            "v": "1.2.3-alpha"
          },
          true
        ]
      ],
      "versionCompare": {
        "lt": [
          ["0.9.99", "1.0.0", true],
          ["0.9.0", "0.10.0", true],
          ["1.0.0-0.0", "1.0.0-0.0.0", true],
          ["1.0.0-9999", "1.0.0--", true],
          ["1.0.0-99", "1.0.0-100", true],
          ["1.0.0-alpha", "1.0.0-alpha.1", true],
          ["1.0.0-alpha.1", "1.0.0-alpha.beta", true],
          ["1.0.0-alpha.beta", "1.0.0-beta", true],
          ["1.0.0-beta", "1.0.0-beta.2", true],
          ["1.0.0-beta.2", "1.0.0-beta.11", true],
          ["1.0.0-beta.11", "1.0.0-rc.1", true],
          ["1.0.0-rc.1", "1.0.0", true],
          ["1.0.0-0", "1.0.0--1", true],
          ["1.0.0-0", "1.0.0-1", true],
          ["1.0.0-1.0", "1.0.0-1.-1", true]
        ],
        "gt": [
          ["0.0.0", "0.0.0-foo", true],
          ["0.0.1", "0.0.0", true],
          ["1.0.0", "0.9.9", true],
          ["0.10.0", "0.9.0", true],
          ["0.99.0", "0.10.0", true],
          ["2.0.0", "1.2.3", true],
          ["v0.0.0", "0.0.0-foo", true],
          ["v0.0.1", "0.0.0", true],
          ["v1.0.0", "0.9.9", true],
          ["v0.10.0", "0.9.0", true],
          ["v0.99.0", "0.10.0", true],
          ["v2.0.0", "1.2.3", true],
          ["0.0.0", "v0.0.0-foo", true],
          ["0.0.1", "v0.0.0", true],
          ["1.0.0", "v0.9.9", true],
          ["0.10.0", "v0.9.0", true],
          ["0.99.0", "v0.10.0", true],
          ["2.0.0", "v1.2.3", true],
          ["1.2.3", "1.2.3-asdf", true],
          ["1.2.3", "1.2.3-4", true],
          ["1.2.3", "1.2.3-4-foo", true],
          ["1.2.3-5-foo", "1.2.3-5", true],
          ["1.2.3-5", "1.2.3-4", true],
          ["1.2.3-5-foo", "1.2.3-5-Foo", true],
          ["3.0.0", "2.7.2+asdf", true],
          ["1.2.3-a.10", "1.2.3-a.5", true],
          ["1.2.3-a.b", "1.2.3-a.5", true],
          ["1.2.3-a.b", "1.2.3-a", true],
          ["1.2.3-a.b.c", "1.2.3-a.b.c.d", false],
          ["1.2.3-a.b.c.10.d.5", "1.2.3-a.b.c.5.d.100", true],
          ["1.2.3-r2", "1.2.3-r100", true],
          ["1.2.3-r100", "1.2.3-R2", true],
          ["a.b.c.d.e.f", "1.2.3", true],
          ["10.0.0", "9.0.0", true],
          ["10000.0.0", "9999.0.0", true]
        ],
        "eq": [
          ["1.2.3", "1.2.3", true],
          ["1.2.3", "v1.2.3", true],
          ["1.2.3-0", "v1.2.3-0", true],
          ["1.2.3-1", "1.2.3-1", true],
          ["1.2.3-1", "v1.2.3-1", true],
          ["1.2.3-beta", "1.2.3-beta", true],
          ["1.2.3-beta", "v1.2.3-beta", true],
          ["1.2.3-beta+build", "1.2.3-beta+otherbuild", true],
          ["1.2.3-beta+build", "v1.2.3-beta+otherbuild", true],
          ["1-2-3", "1.2.3", true],
          ["1-2-3", "1-2.3+build99", true],
          ["1-2-3", "v1.2.3", true],
          ["1.2.3.4", "1.2.3-4", true]
        ]
      },
      "hash": [
        [
          "a",
          0.22
        ],
        [
          "b",
          0.077
        ],
        [
          "ab",
          0.946
        ],
        [
          "def",
          0.652
        ],
        [
          "8952klfjas09ujkasdf",
          0.549
        ],
        [
          "123",
          0.011
        ],
        [
          "___)((*\":&",
          0.563
        ]
      ],
      "getBucketRange": [
        [
          "normal 50/50",
          [
            2,
            1,
            null
          ],
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ]
        ],
        [
          "reduced coverage",
          [
            2,
            0.5,
            null
          ],
          [
            [
              0,
              0.25
            ],
            [
              0.5,
              0.75
            ]
          ]
        ],
        [
          "zero coverage",
          [
            2,
            0,
            null
          ],
          [
            [
              0,
              0
            ],
            [
              0.5,
              0.5
            ]
          ]
        ],
        [
          "4 variations",
          [
            4,
            1,
            null
          ],
          [
            [
              0,
              0.25
            ],
            [
              0.25,
              0.5
            ],
            [
              0.5,
              0.75
            ],
            [
              0.75,
              1
            ]
          ]
        ],
        [
          "uneven weights",
          [
            2,
            1,
            [
              0.4,
              0.6
            ]
          ],
          [
            [
              0,
              0.4
            ],
            [
              0.4,
              1
            ]
          ]
        ],
        [
          "uneven weights, 3 variations",
          [
            3,
            1,
            [
              0.2,
              0.3,
              0.5
            ]
          ],
          [
            [
              0,
              0.2
            ],
            [
              0.2,
              0.5
            ],
            [
              0.5,
              1
            ]
          ]
        ],
        [
          "uneven weights, reduced coverage, 3 variations",
          [
            3,
            0.2,
            [
              0.2,
              0.3,
              0.5
            ]
          ],
          [
            [
              0,
              0.04
            ],
            [
              0.2,
              0.26
            ],
            [
              0.5,
              0.6
            ]
          ]
        ],
        [
          "negative coverage",
          [
            2,
            -0.2,
            null
          ],
          [
            [
              0,
              0
            ],
            [
              0.5,
              0.5
            ]
          ]
        ],
        [
          "coverage above 1",
          [
            2,
            1.5,
            null
          ],
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ]
        ],
        [
          "weights sum below 1",
          [
            2,
            1,
            [
              0.4,
              0.1
            ]
          ],
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ]
        ],
        [
          "weights sum above 1",
          [
            2,
            1,
            [
              0.7,
              0.6
            ]
          ],
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ]
        ],
        [
          "weights.length not equal to num variations",
          [
            4,
            1,
            [
              0.4,
              0.4,
              0.2
            ]
          ],
          [
            [
              0,
              0.25
            ],
            [
              0.25,
              0.5
            ],
            [
              0.5,
              0.75
            ],
            [
              0.75,
              1
            ]
          ]
        ],
        [
          "weights sum almost equals 1",
          [
            2,
            1,
            [
              0.4,
              0.5999
            ]
          ],
          [
            [
              0,
              0.4
            ],
            [
              0.4,
              0.9999
            ]
          ]
        ]
      ],
      "feature": [
        [
          "unknown feature key",
          {
            
          },
          "my-feature",
          {
            "value": null,
            "on": false,
            "off": true,
            "source": "unknownFeature"
          }
        ],
        [
          "defaults when empty",
          {
            "features": {
              "feature": {
                
              }
            }
          },
          "feature",
          {
            "value": null,
            "on": false,
            "off": true,
            "source": "defaultValue"
          }
        ],
        [
          "uses defaultValue - number",
          {
            "features": {
              "feature": {
                "defaultValue": 1
              }
            }
          },
          "feature",
          {
            "value": 1,
            "on": true,
            "off": false,
            "source": "defaultValue"
          }
        ],
        [
          "uses custom values - string",
          {
            "features": {
              "feature": {
                "defaultValue": "yes"
              }
            }
          },
          "feature",
          {
            "value": "yes",
            "on": true,
            "off": false,
            "source": "defaultValue"
          }
        ],
        [
          "force rules",
          {
            "features": {
              "feature": {
                "defaultValue": 2,
                "rules": [
                  {
                    "force": 1
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 1,
            "on": true,
            "off": false,
            "source": "force"
          }
        ],
        [
          "force rules - coverage included",
          {
            "attributes": {
              "id": "3"
            },
            "features": {
              "feature": {
                "defaultValue": 2,
                "rules": [
                  {
                    "force": 1,
                    "coverage": 0.5
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 1,
            "on": true,
            "off": false,
            "source": "force"
          }
        ],
        [
          "force rules - coverage excluded",
          {
            "attributes": {
              "id": "1"
            },
            "features": {
              "feature": {
                "defaultValue": 2,
                "rules": [
                  {
                    "force": 1,
                    "coverage": 0.5
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 2,
            "on": true,
            "off": false,
            "source": "defaultValue"
          }
        ],
        [
          "force rules - coverage missing hashAttribute",
          {
            "attributes": {
              
            },
            "features": {
              "feature": {
                "defaultValue": 2,
                "rules": [
                  {
                    "force": 1,
                    "coverage": 0.5
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 2,
            "on": true,
            "off": false,
            "source": "defaultValue"
          }
        ],
        [
          "force rules - condition pass",
          {
            "attributes": {
              "country": "US",
              "browser": "firefox"
            },
            "features": {
              "feature": {
                "defaultValue": 2,
                "rules": [
                  {
                    "force": 1,
                    "condition": {
                      "country": {
                        "$in": [
                          "US",
                          "CA"
                        ]
                      },
                      "browser": "firefox"
                    }
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 1,
            "on": true,
            "off": false,
            "source": "force"
          }
        ],
        [
          "force rules - condition fail",
          {
            "attributes": {
              "country": "US",
              "browser": "chrome"
            },
            "features": {
              "feature": {
                "defaultValue": 2,
                "rules": [
                  {
                    "force": 1,
                    "condition": {
                      "country": {
                        "$in": [
                          "US",
                          "CA"
                        ]
                      },
                      "browser": "firefox"
                    }
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 2,
            "on": true,
            "off": false,
            "source": "defaultValue"
          }
        ],
        [
          "ignores empty rules",
          {
            "features": {
              "feature": {
                "rules": [
                  {
                    
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": null,
            "on": false,
            "off": true,
            "source": "defaultValue"
          }
        ],
        [
          "empty experiment rule - c",
          {
            "attributes": {
              "id": "123"
            },
            "features": {
              "feature": {
                "rules": [
                  {
                    "variations": [
                      "a",
                      "b",
                      "c"
                    ]
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": "c",
            "on": true,
            "off": false,
            "experiment": {
              "key": "feature",
              "variations": [
                "a",
                "b",
                "c"
              ]
            },
            "experimentResult": {
              "value": "c",
              "variationId": 2,
              "inExperiment": true,
              "hashAttribute": "id",
              "hashValue": "123"
            },
            "source": "experiment"
          }
        ],
        [
          "empty experiment rule - a",
          {
            "attributes": {
              "id": "456"
            },
            "features": {
              "feature": {
                "rules": [
                  {
                    "variations": [
                      "a",
                      "b",
                      "c"
                    ]
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": "a",
            "on": true,
            "off": false,
            "experiment": {
              "key": "feature",
              "variations": [
                "a",
                "b",
                "c"
              ]
            },
            "experimentResult": {
              "value": "a",
              "variationId": 0,
              "inExperiment": true,
              "hashAttribute": "id",
              "hashValue": "456"
            },
            "source": "experiment"
          }
        ],
        [
          "empty experiment rule - b",
          {
            "attributes": {
              "id": "fds"
            },
            "features": {
              "feature": {
                "rules": [
                  {
                    "variations": [
                      "a",
                      "b",
                      "c"
                    ]
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": "b",
            "on": true,
            "off": false,
            "experiment": {
              "key": "feature",
              "variations": [
                "a",
                "b",
                "c"
              ]
            },
            "experimentResult": {
              "value": "b",
              "variationId": 1,
              "inExperiment": true,
              "hashAttribute": "id",
              "hashValue": "fds"
            },
            "source": "experiment"
          }
        ],
        [
          "creates experiments properly",
          {
            "attributes": {
              "anonId": "123",
              "premium": true
            },
            "features": {
              "feature": {
                "rules": [
                  {
                    "coverage": 0.99,
                    "hashAttribute": "anonId",
                    "namespace": [
                      "pricing",
                      0,
                      1
                    ],
                    "key": "hello",
                    "variations": [
                      true,
                      false
                    ],
                    "weights": [
                      0.1,
                      0.9
                    ],
                    "condition": {
                      "premium": true
                    }
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": false,
            "on": false,
            "off": true,
            "source": "experiment",
            "experiment": {
              "coverage": 0.99,
              "hashAttribute": "anonId",
              "namespace": [
                "pricing",
                0,
                1
              ],
              "key": "hello",
              "variations": [
                true,
                false
              ],
              "weights": [
                0.1,
                0.9
              ]
            },
            "experimentResult": {
              "value": false,
              "variationId": 1,
              "inExperiment": true,
              "hashAttribute": "anonId",
              "hashValue": "123"
            }
          }
        ],
        [
          "rule orders - skip 1",
          {
            "attributes": {
              "browser": "firefox"
            },
            "features": {
              "feature": {
                "defaultValue": 0,
                "rules": [
                  {
                    "force": 1,
                    "condition": {
                      "browser": "chrome"
                    }
                  },
                  {
                    "force": 2,
                    "condition": {
                      "browser": "firefox"
                    }
                  },
                  {
                    "force": 3,
                    "condition": {
                      "browser": "safari"
                    }
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 2,
            "on": true,
            "off": false,
            "source": "force"
          }
        ],
        [
          "rule orders - skip 1,2",
          {
            "attributes": {
              "browser": "safari"
            },
            "features": {
              "feature": {
                "defaultValue": 0,
                "rules": [
                  {
                    "force": 1,
                    "condition": {
                      "browser": "chrome"
                    }
                  },
                  {
                    "force": 2,
                    "condition": {
                      "browser": "firefox"
                    }
                  },
                  {
                    "force": 3,
                    "condition": {
                      "browser": "safari"
                    }
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 3,
            "on": true,
            "off": false,
            "source": "force"
          }
        ],
        [
          "rule orders - skip all",
          {
            "attributes": {
              "browser": "ie"
            },
            "features": {
              "feature": {
                "defaultValue": 0,
                "rules": [
                  {
                    "force": 1,
                    "condition": {
                      "browser": "chrome"
                    }
                  },
                  {
                    "force": 2,
                    "condition": {
                      "browser": "firefox"
                    }
                  },
                  {
                    "force": 3,
                    "condition": {
                      "browser": "safari"
                    }
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 0,
            "on": false,
            "off": true,
            "source": "defaultValue"
          }
        ],
        [
          "skips experiment on coverage",
          {
            "attributes": {
              "id": "123"
            },
            "features": {
              "feature": {
                "defaultValue": 0,
                "rules": [
                  {
                    "variations": [
                      0,
                      1,
                      2,
                      3
                    ],
                    "coverage": 0.01
                  },
                  {
                    "force": 3
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 3,
            "on": true,
            "off": false,
            "source": "force"
          }
        ],
        [
          "skips experiment on namespace",
          {
            "attributes": {
              "id": "123"
            },
            "features": {
              "feature": {
                "defaultValue": 0,
                "rules": [
                  {
                    "variations": [
                      0,
                      1,
                      2,
                      3
                    ],
                    "namespace": [
                      "pricing",
                      0,
                      0.01
                    ]
                  },
                  {
                    "force": 3
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 3,
            "on": true,
            "off": false,
            "source": "force"
          }
        ],
        [
          "skip experiment on missing hashAttribute",
          {
            "attributes": {
              "id": "123"
            },
            "features": {
              "feature": {
                "defaultValue": 0,
                "rules": [
                  {
                    "variations": [
                      0,
                      1,
                      2,
                      3
                    ],
                    "hashAttribute": "company"
                  },
                  {
                    "force": 3
                  }
                ]
              }
            }
          },
          "feature",
          {
            "value": 3,
            "on": true,
            "off": false,
            "source": "force"
          }
        ]
      ],
      "run": [
        [
          "default weights - 1",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          1,
          true
        ],
        [
          "default weights - 2",
          {
            "attributes": {
              "id": "2"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          true
        ],
        [
          "default weights - 3",
          {
            "attributes": {
              "id": "3"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          true
        ],
        [
          "default weights - 4",
          {
            "attributes": {
              "id": "4"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          1,
          true
        ],
        [
          "default weights - 5",
          {
            "attributes": {
              "id": "5"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          1,
          true
        ],
        [
          "default weights - 6",
          {
            "attributes": {
              "id": "6"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          1,
          true
        ],
        [
          "default weights - 7",
          {
            "attributes": {
              "id": "7"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          true
        ],
        [
          "default weights - 8",
          {
            "attributes": {
              "id": "8"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          1,
          true
        ],
        [
          "default weights - 9",
          {
            "attributes": {
              "id": "9"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          true
        ],
        [
          "uneven weights - 1",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          1,
          true
        ],
        [
          "uneven weights - 2",
          {
            "attributes": {
              "id": "2"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          1,
          true
        ],
        [
          "uneven weights - 3",
          {
            "attributes": {
              "id": "3"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          0,
          true
        ],
        [
          "uneven weights - 4",
          {
            "attributes": {
              "id": "4"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          1,
          true
        ],
        [
          "uneven weights - 5",
          {
            "attributes": {
              "id": "5"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          1,
          true
        ],
        [
          "uneven weights - 6",
          {
            "attributes": {
              "id": "6"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          1,
          true
        ],
        [
          "uneven weights - 7",
          {
            "attributes": {
              "id": "7"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          0,
          true
        ],
        [
          "uneven weights - 8",
          {
            "attributes": {
              "id": "8"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          1,
          true
        ],
        [
          "uneven weights - 9",
          {
            "attributes": {
              "id": "9"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "weights": [
              0.1,
              0.9
            ]
          },
          1,
          true
        ],
        [
          "coverage - 1",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          0,
          false
        ],
        [
          "coverage - 2",
          {
            "attributes": {
              "id": "2"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          0,
          true
        ],
        [
          "coverage - 3",
          {
            "attributes": {
              "id": "3"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          0,
          true
        ],
        [
          "coverage - 4",
          {
            "attributes": {
              "id": "4"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          0,
          false
        ],
        [
          "coverage - 5",
          {
            "attributes": {
              "id": "5"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          1,
          true
        ],
        [
          "coverage - 6",
          {
            "attributes": {
              "id": "6"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          0,
          false
        ],
        [
          "coverage - 7",
          {
            "attributes": {
              "id": "7"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          0,
          true
        ],
        [
          "coverage - 8",
          {
            "attributes": {
              "id": "8"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          1,
          true
        ],
        [
          "coverage - 9",
          {
            "attributes": {
              "id": "9"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "coverage": 0.4
          },
          0,
          false
        ],
        [
          "three way test - 1",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          2,
          true
        ],
        [
          "three way test - 2",
          {
            "attributes": {
              "id": "2"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          0,
          true
        ],
        [
          "three way test - 3",
          {
            "attributes": {
              "id": "3"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          0,
          true
        ],
        [
          "three way test - 4",
          {
            "attributes": {
              "id": "4"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          2,
          true
        ],
        [
          "three way test - 5",
          {
            "attributes": {
              "id": "5"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          1,
          true
        ],
        [
          "three way test - 6",
          {
            "attributes": {
              "id": "6"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          2,
          true
        ],
        [
          "three way test - 7",
          {
            "attributes": {
              "id": "7"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          0,
          true
        ],
        [
          "three way test - 8",
          {
            "attributes": {
              "id": "8"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          1,
          true
        ],
        [
          "three way test - 9",
          {
            "attributes": {
              "id": "9"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1,
              2
            ]
          },
          0,
          true
        ],
        [
          "test name - my-test",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          1,
          true
        ],
        [
          "test name - my-test-3",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test-3",
            "variations": [
              0,
              1
            ]
          },
          0,
          true
        ],
        [
          "empty id",
          {
            "attributes": {
              "id": ""
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          false
        ],
        [
          "missing id",
          {
            "attributes": {
              
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          false
        ],
        [
          "missing attributes",
          {
            
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          false
        ],
        [
          "single variation",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0
            ]
          },
          0,
          false
        ],
        [
          "negative forced variation",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "force": -8
          },
          0,
          false
        ],
        [
          "high forced variation",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "force": 25
          },
          0,
          false
        ],
        [
          "evaluates conditions - pass",
          {
            "attributes": {
              "id": "1",
              "browser": "firefox"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "condition": {
              "browser": "firefox"
            }
          },
          1,
          true
        ],
        [
          "evaluates conditions - fail",
          {
            "attributes": {
              "id": "1",
              "browser": "chrome"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "condition": {
              "browser": "firefox"
            }
          },
          0,
          false
        ],
        [
          "custom hashAttribute",
          {
            "attributes": {
              "id": "2",
              "companyId": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "hashAttribute": "companyId"
          },
          1,
          true
        ],
        [
          "globally disabled",
          {
            "attributes": {
              "id": "1"
            },
            "enabled": false
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          false
        ],
        [
          "run active experiments",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "active": true,
            "variations": [
              0,
              1
            ]
          },
          1,
          true
        ],
        [
          "skip inactive experiments",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "active": false,
            "variations": [
              0,
              1
            ]
          },
          0,
          false
        ],
        [
          "coverage take precendence over forced",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "force": 1,
            "coverage": 0.01,
            "variations": [
              0,
              1
            ]
          },
          0,
          false
        ],
        [
          "JSON values for experiments",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              {
                "color": "blue",
                "size": "small"
              },
              {
                "color": "green",
                "size": "large"
              }
            ]
          },
          {
            "color": "green",
            "size": "large"
          },
          true
        ],
        [
    "Force variation from context",
    {
      "attributes": {
        "id": "1"
      },
      "forcedVariations": {
        "my-test": 0
      }
    },
    {
      "key": "my-test",
      "variations": [
        0,
        1
      ]
    },
    0,
    false
  ],
        [
          "Skips experiments in QA mode",
          {
            "attributes": {
              "id": "1"
            },
            "qaMode": true
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          0,
          false
        ],
        [
          "Works in QA mode if forced in context",
          {
            "attributes": {
              "id": "1"
            },
            "qaMode": true,
            "forcedVariations": {
              "my-test": 1
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ]
          },
          1,
          false
        ],
        [
    "Works in QA mode if forced in experiment",
    {
      "attributes": {
        "id": "1"
      },
      "qaMode": true
    },
    {
      "key": "my-test",
      "variations": [
        0,
        1
      ],
      "force": 1
    },
    1,
    false
  ],
        [
          "Experiment namespace - pass",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "namespace": [
              "namespace",
              0.1,
              1
            ]
          },
          1,
          true
        ],
        [
          "Experiment namespace - fail",
          {
            "attributes": {
              "id": "1"
            }
          },
          {
            "key": "my-test",
            "variations": [
              0,
              1
            ],
            "namespace": [
              "namespace",
              0,
              0.1
            ]
          },
          0,
          false
        ]
      ],
      "chooseVariation": [
        [
          "even range, 0.2",
          0.2,
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ],
          0
        ],
        [
          "even range, 0.4",
          0.4,
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ],
          0
        ],
        [
          "even range, 0.6",
          0.6,
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ],
          1
        ],
        [
          "even range, 0.8",
          0.8,
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ],
          1
        ],
        [
          "even range, 0",
          0,
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ],
          0
        ],
        [
          "even range, 0.5",
          0.5,
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              1
            ]
          ],
          1
        ],
        [
          "reduced range, 0.2",
          0.2,
          [
            [
              0,
              0.25
            ],
            [
              0.5,
              0.75
            ]
          ],
          0
        ],
        [
          "reduced range, 0.4",
          0.4,
          [
            [
              0,
              0.25
            ],
            [
              0.5,
              0.75
            ]
          ],
          -1
        ],
        [
          "reduced range, 0.6",
          0.6,
          [
            [
              0,
              0.25
            ],
            [
              0.5,
              0.75
            ]
          ],
          1
        ],
        [
          "reduced range, 0.8",
          0.8,
          [
            [
              0,
              0.25
            ],
            [
              0.5,
              0.75
            ]
          ],
          -1
        ],
        [
          "reduced range, 0.25",
          0.25,
          [
            [
              0,
              0.25
            ],
            [
              0.5,
              0.75
            ]
          ],
          -1
        ],
        [
          "reduced range, 0.5",
          0.5,
          [
            [
              0,
              0.25
            ],
            [
              0.5,
              0.75
            ]
          ],
          1
        ],
        [
          "zero range",
          0.5,
          [
            [
              0,
              0.5
            ],
            [
              0.5,
              0.5
            ],
            [
              0.5,
              1
            ]
          ],
          2
        ]
      ],
      "inNamespace": [
        [
          "user 1, namespace1, 1",
          "1",
          [
            "namespace1",
            0,
            0.4
          ],
          false
        ],
        [
          "user 1, namespace1, 2",
          "1",
          [
            "namespace1",
            0.4,
            1
          ],
          true
        ],
        [
          "user 1, namespace2, 1",
          "1",
          [
            "namespace2",
            0,
            0.4
          ],
          false
        ],
        [
          "user 1, namespace2, 2",
          "1",
          [
            "namespace2",
            0.4,
            1
          ],
          true
        ],
        [
          "user 2, namespace1, 1",
          "2",
          [
            "namespace1",
            0,
            0.4
          ],
          false
        ],
        [
          "user 2, namespace1, 2",
          "2",
          [
            "namespace1",
            0.4,
            1
          ],
          true
        ],
        [
          "user 2, namespace2, 1",
          "2",
          [
            "namespace2",
            0,
            0.4
          ],
          false
        ],
        [
          "user 2, namespace2, 2",
          "2",
          [
            "namespace2",
            0.4,
            1
          ],
          true
        ],
        [
          "user 3, namespace1, 1",
          "3",
          [
            "namespace1",
            0,
            0.4
          ],
          false
        ],
        [
          "user 3, namespace1, 2",
          "3",
          [
            "namespace1",
            0.4,
            1
          ],
          true
        ],
        [
          "user 3, namespace2, 1",
          "3",
          [
            "namespace2",
            0,
            0.4
          ],
          true
        ],
        [
          "user 3, namespace2, 2",
          "3",
          [
            "namespace2",
            0.4,
            1
          ],
          false
        ],
        [
          "user 4, namespace1, 1",
          "4",
          [
            "namespace1",
            0,
            0.4
          ],
          false
        ],
        [
          "user 4, namespace1, 2",
          "4",
          [
            "namespace1",
            0.4,
            1
          ],
          true
        ],
        [
          "user 4, namespace2, 1",
          "4",
          [
            "namespace2",
            0,
            0.4
          ],
          true
        ],
        [
          "user 4, namespace2, 2",
          "4",
          [
            "namespace2",
            0.4,
            1
          ],
          false
        ]
      ],
      "getEqualWeights": [
        [
          -1,
          [
            
          ]
        ],
        [
          0,
          [
            
          ]
        ],
        [
          1,
          [
            1
          ]
        ],
        [
          2,
          [
            0.5,
            0.5
          ]
        ],
        [
          3,
          [
            0.33333333,
            0.33333333,
            0.33333333
          ]
        ],
        [
          4,
          [
            0.25,
            0.25,
            0.25,
            0.25
          ]
        ]
      ],
      "paddedVersionString": [
        [
          "1.2.3.4",
          "    1-    2-    3-    4"
        ],
        [
          "v1.2.3-rc.1+build123",
          "    1-    2-    3-rc-    1"
        ],
        [
          "v1.0.0",
          "    1-    0-    0-~"
        ],
        [
          "v987.65.4321-beta.0+build1337",
          "  987-   65- 4321-beta-    0"
        ]
      ]
    }
''';
