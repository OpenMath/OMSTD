/**
 * TypeScript Definitions for an OpenMath JSON encoding
 * 
 * (c) Tom Wiesing 2018-19
 * @license CC-BY-3.0
 */

// WARNING: After updating this file, run "yarn saveschema" to generate the new schema

/** Any OpenMath element (or related element) */
export type omany = OMOBJ | OMFOREIGN | omel;

/** OpenMath Object Constructor */
export interface OMOBJ extends withCD {
    kind: 'OMOBJ'
    openmath?: '2.0'

    object: omel
}

/** Elements which can appear inside an OpenMath object */
export type omel = OMS | OMV | OMI | OMB | OMSTR | OMF | OMA | OMBIND | OME | OMATTR | OMR;


/** Symbol */
export interface OMS extends withCD {
    kind: 'OMS'

    /** content dictonary the symbol is in */
    cd: name

    /** name of the symbol */
    name: name
}


/** Variable */
export interface OMV extends referencable {
    kind: 'OMV'

    /** the name of the variable */
    name: name
}

/** an integer */
export type OMI = omiint | omidec | omihex;

interface omikind extends referencable { kind: 'OMI' }
interface omiint extends omikind { integer:     integer }
interface omidec extends omikind { decimal:     decimalInteger }
interface omihex extends omikind { hexadecimal: hexInteger }

/** IEEE floating point */
export type OMF = omffloat | omfdec | omfhex;

interface omfkind  extends referencable { kind: 'OMF' }
interface omffloat extends omfkind { float:       float }
interface omfdec   extends omfkind { decimal:     decimalFloat }
interface omfhex   extends omfkind { hexadecimal: hexFloat }

/** bytes */
export type OMB = ombbytes | ombbase64;

interface ombkind extends referencable { kind: 'OMB' }
interface ombbytes  extends ombkind { bytes: byte[] }
interface ombbase64 extends ombkind { base64: base64string }

/** String */
export interface OMSTR extends referencable {
    kind: 'OMSTR'

    /** the string */
    string: string
}

/** Application */
export interface OMA extends withCD {
    kind: 'OMA'

    /** the term that is being applied */
    applicant: omel

    /** the arguments that the applicant is being applied to */
    arguments?: omel[]
}

/** Attributed object */
export interface OMATTR extends withCD {
    kind: 'OMATTR'

    /** attributes attributed to this object */
    attributes: omattributes

    /** object that is being attributed */
    object: omel
}

/**
 * Attributes for the OMATTR Constructor
 * @minItems 1
*/
type omattributes = ([OMS, omel|OMFOREIGN])[];

/** Binding */
export interface OMBIND extends withCD {
    kind: 'OMBIND'

    /** the binder being used */
    binder: omel

    /** the variables being bound */
    variables: attvars

    /** the object that is being bound */
    object: omel
}

/**
 * List of variables or attributed variables
 * @minItems 1
 */
type attvars = (OMV | attvar)[];

/** Attributed variable */
interface attvar extends OMATTR {
    object: OMV
}

/** Error */
export interface OME extends referencable {
    kind: 'OME'

    /** the error that has occured */
    error: OMS

    /** arguments to the error  */
    arguments?: (omel|OMFOREIGN)[]
}

/** Non-OpenMath object  */
export interface OMFOREIGN extends withCD {
    kind: 'OMFOREIGN'

    /** encoding of the foreign object */
    encoding?: string

    /** the foreign object, usually a string */
    foreign: any
}

/** Reference to another element within the same structure */
export interface OMR extends referencable {
    kind: 'OMR'

    /** element that is being referenced */
    href: uri
}

// #region "base"

/** any element */
interface element {
    /** the kind of OpenMath Element this type describes */
    kind: string
}

/** any element that can be referenced */
interface referencable extends element {
    /** id of this element, if it is used for structure sharing */
    id?: name
}

/** any elements that can have a CDBase */
interface withCD extends referencable {
    /** base URI to use for any cds within this element */
    cdbase?: uri
}

// #endregion


// #region "Helpers"

/**
 * A URI
 * 
 * @format uri-reference
 */
type uri = string;

/**
 * A valid name
 */
type name = string;

/**
 * An integer
 * 
 * @asType integer
 */
type integer = number;

/**
 * A string representing a decimal integer
 * 
 * @pattern ^-?[0-9]+$
 */
type decimalInteger = string;

/**
 * A string representing a hexadecimal integer
 * 
 * @pattern ^-?x[0-9A-F]+$
 */
type hexInteger = string;

/**
 * A floating point number. 
 * Should not be NaN, +Infinity or -Infinity. 
 * 
 * Represented via a native JSON representation
 */
type float = number;

/**
 * A string representing a decimal floating-point number
 * 
 * @pattern ^(-?)([0-9]+)?(\.[0-9]+)?([eE](-?)[0-9]+)?$
 */
type decimalFloat = string;

/** A string representing a hexa-decimal floating-point number
 * 
 * @pattern ^([0-9A-F]+)$
 */
type hexFloat = string;

/**
 * A byte
 * 
 * @minimum 0
 * @exclusiveMinimum false
 * @maximum 255
 * @exclusiveMaximum false
 * @asType integer
 */
type byte = number;

/**
 * Base64-encoded string
 * 
 * @pattern ^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$
 */
type base64string = string;

// #endregion