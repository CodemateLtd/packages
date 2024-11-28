// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#ifndef PACKAGES_CAMERA_CAMERA_WINDOWS_WINDOWS_TASK_RUNNER_H_
#define PACKAGES_CAMERA_CAMERA_WINDOWS_WINDOWS_TASK_RUNNER_H_

#include <functional>

namespace camera_windows {

using TaskClosure = std::function<void()>;

class TaskRunner {
 public:
  virtual void EnqueueTask(TaskClosure task) = 0;
};

}  // namespace camera_windows

#endif  // PACKAGES_CAMERA_CAMERA_WINDOWS_WINDOWS_TASK_RUNNER_H_