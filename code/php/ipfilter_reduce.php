<?php

/*
 * Reduce the size of an ipfilter.dat by merging ip ranges
 */

/**
 *
 */
class RangeSet
{
    private $lowerBound;
    private $upperBound;

    /**
     *
     * @param int $lowerBound
     * @param int $upperBound
     * @throws \RuntimeException
     */
    function __construct($lowerBound, $upperBound)
    {
        if ($lowerBound > $upperBound) {
            throw new \RuntimeException();
        }

        $this->lowerBound = $lowerBound;
        $this->upperBound = $upperBound;
    }

    /**
     *
     * @param RangeSet $rangeSet
     * @return boolean
     */
    public function join(RangeSet $rangeSet)
    {
        $isJoinable = $this->lowerBound - 1 <= $rangeSet->getUpperBound() &&
            $rangeSet->getLowerBound() - 1 <= $this->upperBound;

        if ($isJoinable) {
            $this->lowerBound = min($this->lowerBound, $rangeSet->lowerBound);
            $this->upperBound = max($this->upperBound, $rangeSet->upperBound);
        }

        return $isJoinable;
    }

    /**
     *
     * @return int
     */
    public function getLowerBound()
    {
        return $this->lowerBound;
    }

    /**
     *
     * @return int
     */
    public function getUpperBound()
    {
        return $this->upperBound;
    }
}

/**
 *
 */
class IpFilterStream extends \SplFileObject
{

    /**
     *
     * @return boolean
     */
    public function eof()
    {
        $currPos = $this->ftell();

        while (!parent::eof() && !self::isRule($this->fgets()));

        $isEof = parent::eof();
        $this->fseek($currPos);

        return $isEof;
    }

    /**
     *
     * @return \stdClass
     * @throws \RuntimeException
     */
    public function getRule()
    {
        do {
            $line = trim($this->fgets()); // We let fgets throw \RuntimeException on eof
        } while (!self::isRule($line));

        return self::parseRule($line);
    }

    /**
     *
     * @param string $line
     * @return boolean
     */
    private static function isRule($line)
    {
        return $line !== '' && $line[0] != '#';
    }

    /**
     *
     * @param string $ruleString
     * @return \stdClass
     * @throws \RuntimeException
     */
    private static function parseRule($ruleString)
    {
        $splitRule = explode(',', $ruleString, 3);

        if (count($splitRule) != 3) {
            throw new \RuntimeException();
        }

        $splitRule = array_map('trim', $splitRule);
        $splitRule[0] = self::parseAddressRange($splitRule[0]);
        $keys = ['addressRange', 'accessLevel', 'description'];

        return (object) array_combine($keys, $splitRule);
    }

    /**
     *
     * @param string $addressRangeString
     * @return \RangeSet
     * @throws \RuntimeException
     */
    private static function parseAddressRange($addressRangeString)
    {
        $splitRange = explode('-', $addressRangeString);

        if (count($splitRange) != 2) {
            throw new \RuntimeException();
        }

        $splitRange = array_map('trim', $splitRange);
        $splitRange = array_map(['self', 'parseAddress'], $splitRange);

        return new RangeSet($splitRange[0], $splitRange[1]);
    }

    /**
     *
     * @param string $addressString
     * @return int
     * @throws \RuntimeException
     */
    private static function parseAddress($addressString)
    {
        $splitAddress = explode('.', $addressString);

        if (count($splitAddress) != 4) {
            throw new \RuntimeException();
        }

        $splitAddress = array_map('intval', $splitAddress);
        $addressString = implode('.', $splitAddress);
        $addressLong = ip2long($addressString);

        if ($addressLong === false) {
            throw new \RuntimeException();
        }

        return $addressLong;
    }
}

/**
 *
 */
class IpFilterParser
{
    private $rangeSet;

    /**
     *
     */
    function __construct($path)
    {
        $ipFilterStream = new IpFilterStream($path);
        $this->rangeSet = new \SplDoublyLinkedList();

        while (!$ipFilterStream->eof()) {
            $rule = $ipFilterStream->getRule()->addressRange;
            $this->rangeSet->push($rule);
            $this->joinRecursive();
        }

        foreach ($this->rangeSet as $range) {
            printf("%s-%s,000,Entry\n", self::formatAddress($range->getLowerBound()), self::formatAddress($range->getUpperBound()));
        }
    }

    /**
     *
     * @param \SplFixedArray $duet
     */
    private function joinRecursive()
    {
        if ($this->rangeSet->count() > 1) {
            $duet[0] = $this->rangeSet->pop();
            $duet[1] = $this->rangeSet->pop();

            if ($duet[0]->join($duet[1])) {
                $this->joinRecursive();
            } else {
                $this->rangeSet->push($duet[1]);
            }

            $this->rangeSet->push($duet[0]);
        }
    }

    /**
     *
     * @param int $addressLong
     * @return string
     */
    private static function formatAddress($addressLong)
    {
        return vsprintf('%03d.%03d.%03d.%03d', explode('.', long2ip($addressLong)));
    }
}

new IpFilterParser(@$argv[1]);
