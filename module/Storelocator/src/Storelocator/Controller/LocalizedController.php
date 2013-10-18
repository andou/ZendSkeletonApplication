<?php

namespace Storelocator\Controller;

use Zend\Mvc\Controller\AbstractActionController;

abstract class LocalizedController extends AbstractActionController {

  const DEFAULT_STORE = 'it_it';

  protected function getStoreCode() {
    return $this->params('store_code') ? strtolower($this->params('store_code')) : strtolower($this->getDefaultStoreCode());
  }

  protected function getDefaultStoreCode() {
    $config = $this->getServiceLocator()->get('config');
    $default_store_code = $config['locale']['default_store_code'];

    return $default_store_code ? $default_store_code : self::DEFAULT_STORE;
  }

}