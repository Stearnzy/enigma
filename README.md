# Enigma
<img src="https://media.giphy.com/media/h0Xez8ow1UOVq/giphy.gif" alt="riddler">

## Table of Contents
- [Overview](#overview)
- [Design Strategy](#design-strategy)
  - [Object Organization](#object-organization)
- [Self Assessment](#self-assessment)

***
## Overview
Enigma is a project that requires deep critical thinking and planning in order to construct.  As a class, we were given high-level guidelines on how the program should work and what things were required of us, but had much less explicit instruction on how to go about making it.  We were presented with the details on how the encryption pattern should be executed but it was up to us to figure out how to build the tool that would execute that encryption pattern.

The main idea of the project is to craft an object-oriented codebase that can both encrypt and decrypt a given message.  A message would be written and passed through the `Enigma` class to be encoded in accordance with the encryption pattern.  That encrypted message could then be passed through the `Enigma` class again to be decoded back to the originally entered text.

***
## Design Strategy
Test-Driven Development is a crucial tool necessary to verify how the individual parts are to be built.  I used stubs in order to account for randomness in a couple parts of the program in order to test accurately.  Initially, I had set up a class for decryption and a class for encryption to see how close the two were.  Utilization of inheritance proved to be useful, as the setup for both encryption and decryption methods were very similar.  Modules were added for both date conversion and to house the couple methods that had to be different for encrypt and decrypt.

### Object Organization
__Cryptograph__
  * The purpose of this class is to hold all the helper methods identical between the `encrypt` and `decrypt` methods.  This object holds the bulk of the logical processes.  

  *  This class makes all the keys for the letter shifts, including one key shift generator that pulls from a random number generator and one offset shift generator that pulls from the current date.  Both of these generators can take a custom set of numbers to override the random number generator and the date retrieval.  

  * These two shift values are added together to make one master offset shift.  This class also splits the entered message and applies the master shift to each letter.

__Modules__
  * _Dateable_ translates the current date into a string and squares it.  This module also squares whatever value is entered to override the current date.

  * _Mappable_ takes the culmination of the `Cryptograph`'s hard work in assigning shifts to each character in the message and maps the shifts it to what the new letter should be, then joins them to be one string.

__Enigma__
  * This class houses the main `encrypt` and `decrpyt` methods.  The methods in this class is made entirely up of the helper methods found in the modules and the `Cryptograph` superclass.  It is this class that interacts with the `.txt` files that supply and store the encrypted and decrypted messages.

__Runners__
  * `encrypt.rb` and `decrypt.rb` are the runner files that execute output to the command line and that read and write to the `encrypted.txt` and `decrypted.txt` files to store the information.

***
## Self-assessment
  * __Functionality - 3__: Encrypt and decrypt methods with command line interfaces successfully implemented.  Cracking method not included.
  * __OOP - 4__: Inheritance and stubs both implemented.  No `lib` class is over 50 lines long and no methods are over 10 lines long.  Superclass to `Enigma` holds all common helper methods found in both `encrypt` and `decrypt` methods.  `Mappable` module implemented to hold the few methods that differ between the encrypt and decrypt processes that map the letter shifts and correlates them to the alphabet index.  `Dateable` module holds the two date-related helper methods.
  * __Ruby Convention - 4__: All methods and tests well named and clear.  Syntax is proper.  Methods stay under 10 lines, and all classes are 50 lines or less.  Specific enumerables given when applicable, and multiple hashes are used.
  * __TDD - 3.5__: Stubs are used in place of randomness for the tests on methods relying on the random number generator and date conversion. Simplecov reports 100% test coverage. However, no mocks are used.
  * __Version Control - 4__: 7 pull requests and over 200 commits, both of which are specific to individual processes.