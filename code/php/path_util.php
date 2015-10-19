<?php

class OptionHandler
{
    protected $optList;

    function __construct($options, array $longOptions = [])
    {
        $this->optList = getopt($options, $longOptions);

        foreach ($this->optList as &$item) {
            if (is_array($item)) {
                $item = array_pop($item);
            }
        }
    }

    public function getOption($option, $longOption)
    {
        $value = null;

        if (isset($this->optList[$option])) {
            $value = $this->optList[$option];
        } elseif (isset($this->optList[$longOption])) {
            $value = $this->optList[$longOption];
        }

        return $value;
    }

    public function hasOption($option, $longOption)
    {
        return !is_null($this->getOption($option, $longOption));
    }
}

class PathHandler
{
    public function add($dir, $index = null)
    {
        $pathList = $this->fetch();
        
        if (is_null($index)) {
            $pathList[] = $dir;
        } elseif (isset($pathList[$index])) {
            array_splice($pathList, $index, 0, $dir);
        } else {
            throw new \RuntimeException();
        }
        
        $this->persist($pathList);
    }

    public function get($index = null)
    {
        $pathList = $this->fetch();

        if (!is_null($index) && isset($pathList[$index])) {
            $dir = $pathList[$index];
        }
        else {
            throw new \RuntimeException();
        }

        return $dir;
    }
    
    public function set($dir, $index = null) {
        $pathList = $this->fetch();
        
        if (!is_null($index) && isset($pathList[$index])) {
            $pathList[$index] = $dir;
        } else {
            throw new \RuntimeException();
        }
        
        $this->persist($pathList);
    }
    
    public function remove($index = null) {
        $pathList = $this->fetch();
        
        if (!is_null($index) && isset($pathList[$index])) {
            array_splice($pathList, $index, 1);
        } else {
            throw new \RuntimeException();
        }
        
        $this->persist($pathList);
    }
    
    public function clean() {
        $pathList = $this->fetch();

        for ($i = 0; $i < count($pathList);) {
            exec('cd ' . $pathList[$i] . ' 2> nul', $_, $ret);
            if ($ret) {
                array_splice($pathList, $i, 1);
            } else {
                ++$i;
            }
        }
        
        $this->persist($pathList);
    }

    public function fetch()
    {
        $shellResult = trim(`reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH`);
        $pathString = preg_replace('/.* {4}/s', '', $shellResult);
        return explode(PATH_SEPARATOR, $pathString);
    }

    private function persist(array $pathList)
    {
        $pathString = implode(PATH_SEPARATOR, $pathList);
        exec('setx PATH "' . $pathString . '" /M');
    }
}

$pathHandler = new PathHandler();
$optionHandler = new OptionHandler('a:gs:ri:lc', ['add:', 'get', 'set:', 'remove', 'index:', 'list', 'clean']);
$index = $optionHandler->getOption('i', 'index');

if ($optionHandler->hasOption('a', 'add')) {
    $dir = $optionHandler->getOption('a', 'add');
    $pathHandler->add($dir, $index);
} elseif ($optionHandler->hasOption('g', 'get')) {
    $dir = $pathHandler->get($index);
    print $dir . "\n";
} elseif ($optionHandler->hasOption('s', 'set')) {
    $dir = $optionHandler->getOption('s', 'set');
    $pathHandler->set($dir, $index);
} elseif ($optionHandler->hasOption('r', 'remove')) {
    $pathHandler->remove($index);
} elseif ($optionHandler->hasOption('l', 'list')) {
    $pathList = $pathHandler->fetch();
    foreach($pathList as $i => $item) {
        printf("% 4d  %s\n", $i, $item);
    }
} elseif ($optionHandler->hasOption('c', 'clean')) {
    $pathHandler->clean();
}
